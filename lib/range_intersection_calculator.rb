class RangeIntersectionCalculator

  def initialize(range_1, range_2)
    @range_1 = range_1
    @range_2 = range_2
  end

  def intersect?
    covers?(range_1, range_2) || covers?(range_2, range_1)
  end

  private

    def covers?(outer_range, inner_range)
      covers_begin?(outer_range, inner_range) || covers_end?(outer_range, inner_range)
    end

    def covers_begin?(outer_range, inner_range)
      outer_range.include?(inner_range.begin)
    end

    def covers_end?(outer_range, inner_range)
      return false if inner_range.exclude_end? && inner_range.end == outer_range.begin
      outer_range.include?(inner_range.end)
    end

    attr_reader :range_1, :range_2

end
