require File.join(File.dirname(__FILE__), "range_intersection_calculator")

class Quadtree

  include Enumerable

  def initialize(x_range, y_range, options = {})
    @x_range = x_range
    @y_range = y_range
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
    (leaf? ? points : child_for(point)) << point
  end

  def each(&block)
    if leaf?
      points.each(&block)
    else
      children.each { |child| child.each(&block) }
    end
  end

  def covers?(point)
    x_range.include?(point.x) && y_range.include?(point.y)
  end

  def within(test_x_range, test_y_range)
    return [] unless intersects?(test_x_range, test_y_range)

    if leaf?
      @points.select do |point|
        test_x_range.include?(point.x) && test_y_range.include?(point.y)
      end
    else
      children.map { |child| child.within(test_x_range, test_y_range) }.flatten # TODO: use flat_map after upgrading ruby
    end
  end

  def depth
    return 0 if leaf?
    children.map(&:depth).max + 1
  end

  private

  attr_reader :x_range, :y_range, :points, :max_depth, :children

  def intersects?(test_x_range, test_y_range)
    x_range_intersects?(test_x_range) && y_range_intersects?(test_y_range)
  end

  def x_range_intersects?(range)
    RangeIntersectionCalculator.new(x_range, range).intersect?
  end

  def y_range_intersects?(range)
    RangeIntersectionCalculator.new(y_range, range).intersect?
  end

  def child_for(point)
    children[child_index_for(point)]
  end

  def child_index_for(point)
    (point.x >= midpoint(x_range) ? 1 : 0) + (point.y >= midpoint(y_range) ? 2 : 0)
  end

  def can_subdivide?
    depth < max_depth
  end

  def subdivide
    x_ranges = subdivide_range(x_range)
    y_ranges = subdivide_range(y_range)
    child_options = {:max_depth => max_depth - 1}

    children[0] = Quadtree.new(x_ranges[0], y_ranges[0], child_options)
    children[1] = Quadtree.new(x_ranges[1], y_ranges[0], child_options)
    children[2] = Quadtree.new(x_ranges[0], y_ranges[1], child_options)
    children[3] = Quadtree.new(x_ranges[1], y_ranges[1], child_options)
  end

  def subdivide_range(range)
    midpoint = midpoint(range)
    [range.begin...midpoint, midpoint...range.end]
  end

  def midpoint(range)
    length = range.end - range.begin
    range.begin + (length / 2.0)
  end

  def leaf?
    children.empty?
  end

end
