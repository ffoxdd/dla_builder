module DCEL; end

class DCEL::Edge

  def initialize(options = {})
    @origin = options.fetch(:origin)
    @previous = options.fetch(:previous, nil)
    @next = options.fetch(:next, nil)
    @twin = options.fetch(:twin, nil)
  end

  attr_reader :previous, :next, :twin

  private

  attr_reader :origin

end
