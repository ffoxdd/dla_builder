module DCEL; end

class DCEL::HalfEdge

  def initialize(options = {})
    @origin = options.fetch(:origin)
    @previous = options.fetch(:previous, nil)
    @next = options.fetch(:next, nil)
    @twin = options.fetch(:twin, nil)
  end

  def link_next(next_half_edge)
    self.next = next_half_edge
    next_half_edge.previous = self
  end

  def link_previous(previous_half_edge)
    self.previous = previous_half_edge
    previous_half_edge.next = self
  end

  attr_reader :origin, :previous, :next, :twin

  protected
  attr_writer :next, :previous

end
