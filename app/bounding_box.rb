require_relative "../lib/range_intersection_calculator"
require_relative "../lib/range_segmenter"

class BoundingBox

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
  end

  attr_reader :x_range, :y_range

  def intersects?(box)
    ranges_intersect?(x_range, box.x_range) && ranges_intersect?(y_range, box.y_range)
  end

  def covers?(point)
    x_range.include?(point.x) && y_range.include?(point.y)
  end

  def quadtrant(i, j)
    BoundingBox.new(segment(x_range, i), segment(y_range, j))
  end

  private

    def segment(range, i)
      RangeSegmenter.new(range, 2).segments[i]
    end

    def ranges_intersect?(range_1, range_2)
      RangeIntersectionCalculator.new(range_1, range_2).intersect?
    end

end
