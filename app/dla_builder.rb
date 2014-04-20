require_relative "dla.rb"

class DlaBuilder

  def initialize(options = {})
    @limit = options.fetch(:limit, 1000)
    @options = options
  end

  def build
    new_dla.tap { |dla| grow(dla) }
  end

  private

    attr_reader :dla, :limit, :options

    def grow(dla)
      dla.grow until done?(dla)
    end

    def done?(dla)
      dla.size >= limit
    end

    def new_dla
      Dla.new(options)
    end

end
