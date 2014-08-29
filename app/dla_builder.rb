require_relative "dla.rb"

class DlaBuilder

  def initialize(options = {})
    @limit = options.fetch(:limit, 10_000)
    @axis_aligned_bounds = options[:within]
    @options = options
  end

  def build
    new_dla.tap { |dla| grow(dla) }
  end

  private

    attr_reader :dla, :options, :limit, :axis_aligned_bounds

    def grow(dla)
      dla.grow until done?(dla)
    end

    def done?(dla)
      reached_limit?(dla) || outside_bounds?(dla)
    end

    def reached_limit?(dla)
      dla.size >= limit
    end

    def outside_bounds?(dla)
      return false unless axis_aligned_bounds
      !dla.within?(axis_aligned_bounds)
    end

    def new_dla
      Dla.new(options)
    end

end
