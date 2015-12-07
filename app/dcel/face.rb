require_relative "builder"

module DCEL; end

class DCEL::Face
  def initialize(edge)
    @edge = edge
  end

  def each_edge
    edge.enumerator(&:next_edge)
  end

  def edges
    each_edge.to_a
  end

  def vertices
    each_edge.map(&:origin_vertex)
  end

  private
  attr_reader :edge


end
