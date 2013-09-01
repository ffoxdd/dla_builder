

class BoundingBox

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
  end

  def intersects?(other_box)
    ranges_intersect?(other_box.x_range, x_range) && ranges_intersect?(other_box.y_range, y_range)
  end

  def cover?(point)
    x_range.cover?(point.x) && y_range.cover?(point.y)
  end

  protected

    attr_reader :x_range, :y_range

  private

    def ranges_intersect?(range_1, range_2)
      RangeIntersectionCalculator.new(range_1, range_2).intersect?
    end

end
