class RangeSegmenter

  def initialize(range, segment_count)
    @range = range
    @segment_count = segment_count
  end

  def segments
    segment_bounds.map { |start, stop| segment(start, stop) }
  end

  private

    attr_reader :range, :segment_count

    def segment(start, stop)
      Range.new(start, stop, exclude_end?(stop))
    end

    def exclude_end?(stop)
      return true if middle_interval?(stop)
      range.exclude_end?
    end

    def middle_interval?(stop)
      stop != range.end
    end

    def segment_bounds
      (range.begin..range.end).step(segment_size).each_cons(2)
    end

    def segment_size
      length / segment_count
    end

    def length
      (range.end - range.begin).to_f
    end
    
end
