module DCEL; end

class DCEL::Vertex

  def initialize(value, edge: nil)
    @value = value
    @edge = edge
  end

  def adjacent_edges
    each_adjacent_edge_enumerator.to_a
  end

  def each_adjacent_edge_enumerator
    edge.each_adjacent_edge_enumerator
  end

  attr_reader :value
  attr_accessor :edge

end
