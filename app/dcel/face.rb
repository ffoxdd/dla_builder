require_relative "builder"

module DCEL; end

class DCEL::Face
  def initialize(edge)
    @edge = edge
  end

  def edges
    next_edge_enumerator.to_a
  end

  def vertices
    next_edge_enumerator.map(&:origin_vertex)
  end

  private
  attr_reader :edge

  def next_edge_enumerator # TODO: move this to DCEL::Edge
    edge.enumerator(&:next_edge)
  end
end
