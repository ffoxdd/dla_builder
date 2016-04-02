class Quadtree

  include Enumerable

  def initialize(bounding_box, options = {})
    @bounding_box = bounding_box
    @max_depth = options.fetch(:max_depth, 6)
    @points = []
    @children = []
  end

  def size
    leaf? ? points.size : children.map(&:size).inject(&:+)
  end

  def <<(point)
    return unless covers?(point)
    subdivide
    (points << point and return) if leaf?
    child_for(point) << point
  end

  def each(&block)
    points.each(&block)
    children.each { |child| child.each(&block) }
  end

  def covers?(point)
    bounding_box.covers?(point)
  end

  def closest_point(point)
    return points.min_by { |p| p.distance(point) } if leaf?

    current_closest_point = nil
    current_min_distance = Float::INFINITY

    children.each do |child|
      next if current_min_distance < child.bounding_box_distance(point)
      child_closest_point = child.closest_point(point)
      next unless child_closest_point

      child_distance = child_closest_point.distance(point)

      if child_distance < current_min_distance
        current_closest_point = child_closest_point
        current_min_distance = child_distance
      end
    end

    current_closest_point
  end

  def depth
    return 0 if leaf?
    children.map(&:depth).max + 1
  end

  protected

  def bounding_box_distance(point)
    bounding_box.distance(point)
  end

  def child_for(point)
    return self if leaf?
    immediate_child_for(point).child_for(point)
  end

  def immediate_child_for(point) # TODO: move this to AABB#quadtrant_index(point)
    x_index_component = point.x >= bounding_box.center.x ? 1 : 0
    y_index_component = point.y >= bounding_box.center.y ? 2 : 0
    children[x_index_component + y_index_component]
  end

  private
  attr_reader :bounding_box, :points, :max_depth, :children

  def leaf?
    children.empty?
  end

  def intersects?(test_bounding_box)
    bounding_box.intersects?(test_bounding_box)
  end

  def can_subdivide?
    return false unless leaf?
    depth < max_depth
  end

  def subdivide
    return unless can_subdivide?

    children[0] = new_child(0, 0)
    children[1] = new_child(1, 0)
    children[2] = new_child(0, 1)
    children[3] = new_child(1, 1)
  end

  def new_child(i, j)
    Quadtree.new(bounding_box.quadtrant(i, j), max_depth: max_depth - 1)
  end

end
