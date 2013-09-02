class BoundingBox

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
  end

  attr_reader :x_range, :y_range

  def intersects?(other_box)
    intersects_x_range?(other_box) && intersects_y_range?(other_box)
  end

  def covers?(point)
    x_range.cover?(point.x) && y_range.cover?(point.y)
  end

  def quadtrant(i, j)
    BoundingBox.new(range_subdivision(x_range, i), range_subdivision(y_range, j))
  end

  private

    def range_subdivision(range, i)
      i == 0 ? first_half(range) : second_half(range)
    end

    def first_half(range)
      Range.new(range.begin, midpoint(range), true)
    end

    def second_half(range)
      Range.new(midpoint(range), range.end, range.exclude_end?)
    end

    def length(range)
      range.end - range.begin
    end

    def midpoint(range)
      range.begin + (length(range) / 2.0)
    end

    def intersects_x_range?(other_box)
      ranges_intersect?(other_box.x_range, x_range)
    end

    def intersects_y_range?(other_box)
      ranges_intersect?(other_box.y_range, y_range)
    end

    def ranges_intersect?(range_1, range_2)
      RangeIntersectionCalculator.new(range_1, range_2).intersect?
    end

end
