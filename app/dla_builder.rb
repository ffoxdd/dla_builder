require_relative "dla.rb"

class DlaBuilder

  def initialize(options = {})
    @limit = options.fetch(:limit, 1000)
    @dla = Dla.new(options)
  end

  def grow
    dla.grow until done?
  end

  private

    attr_reader :dla, :limit

    def done?
      dla.size >= limit
    end

end
