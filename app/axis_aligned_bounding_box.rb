require_relative "vector2d"
require_relative "../lib/range_intersection_calculator"
require_relative "../lib/range_segmenter"

class AxisAlignedBoundingBox

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
  end

  attr_reader :x_range, :y_range

  def ==(box)
    (x_range == box.x_range) && (y_range == box.y_range)
  end

  def intersects?(box)
    ranges_intersect?(x_range, box.x_range) && ranges_intersect?(y_range, box.y_range)
  end

  def covers?(point)
    x_range.include?(point.x) && y_range.include?(point.y)
  end

  def quadtrant(i, j)
    AxisAlignedBoundingBox.new(segment(x_range, i), segment(y_range, j))
  end

  def perimeter
    (width + height) * 2
  end

  def offset
    Vector2D[x_range.begin, y_range.begin]
  end

  def at_origin
    self - offset
  end

  def +(vector)
    AxisAlignedBoundingBox.new(
      translate_range(x_range, vector[0]),
      translate_range(y_range, vector[1])
    )
  end

  def -(vector)
    self + (vector * -1)
  end

  private

    def segment(range, i)
      RangeSegmenter.new(range, 2).segments[i]
    end

    def ranges_intersect?(range_1, range_2)
      RangeIntersectionCalculator.new(range_1, range_2).intersect?
    end

    def width
      measure(x_range)
    end

    def height
      measure(y_range)
    end

    def measure(range)
      range.last - range.first
    end

    def translate_range(range, offset)
      Range.new(range.begin + offset, range.end + offset, range.exclude_end?)
    end

end
