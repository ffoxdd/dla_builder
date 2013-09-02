require File.join(File.dirname(__FILE__), "..", "lib", "range_intersection_calculator")
require File.join(File.dirname(__FILE__), "..", "app", "bounding_box")

class Quadtree

  include Enumerable

  def initialize(bounding_box, options = {})
    @bounding_box = bounding_box
    @max_depth = options.fetch(:max_depth) { 6 }
    @points = []
    @children = []
  end

  def size
    leaf? ? points.size : children.map(&:size).inject(&:+)
  end

  def <<(point)
    return unless covers?(point)
    subdivide if leaf? && can_subdivide?

    points << point if leaf?
    children.each { |child| child << point }
  end

  def each(&block)
    points.each(&block)
    children.each { |child| child.each(&block) }
  end

  def covers?(point)
    bounding_box.covers?(point)
  end

  def within(test_x_range, test_y_range)
    test_bounding_box = BoundingBox.new(test_x_range, test_y_range)
    return [] unless intersects?(test_bounding_box)

    if leaf?
      @points.select { |point| test_bounding_box.covers?(point) }
    else
      children.map { |child| child.within(test_x_range, test_y_range) }.flatten # TODO: use flat_map after upgrading ruby
    end
  end

  def depth
    return 0 if leaf?
    children.map(&:depth).max + 1
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
    depth < max_depth
  end

  def subdivide
    children[0] = new_child(0, 0)
    children[1] = new_child(1, 0)
    children[2] = new_child(0, 1)
    children[3] = new_child(1, 1)
  end

  def new_child(i, j)
    Quadtree.new(bounding_box.quadtrant(i, j), :max_depth => max_depth - 1)
  end

end
