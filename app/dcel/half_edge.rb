module DCEL; end

class DCEL::HalfEdge

  def initialize(options = {})
    @origin = options.fetch(:origin)
    @previous = options.fetch(:previous, nil)
    @next = options.fetch(:next, nil)
    @twin = options.fetch(:twin, nil)
  end

  attr_reader :origin, :previous, :next, :twin

  def link_next(next_half_edge)
    self.next = next_half_edge
    next_half_edge.previous = self
  end

  def link_previous(previous_half_edge)
    self.previous = previous_half_edge
    previous_half_edge.next = self
  end

  def link_twin(twin_half_edge)
    self.twin = twin_half_edge
    twin_half_edge.twin = self
  end

  def each_perimeter
    Enumerator.new do |y|
      self.tap do |current_half_edge|
        loop do
          y << current_half_edge
          current_half_edge = current_half_edge.next
          break if current_half_edge.nil? || current_half_edge == self
        end
      end
    end
  end

  protected

  attr_writer :next, :previous, :twin

end
