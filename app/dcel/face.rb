require_relative "builder"

module DCEL; end

class DCEL::Face
  def initialize(edge)
    @edge = edge
  end

  def edges
    each_edge.to_a
  end

  def vertices
    each_edge.map(&:origin_vertex)
  end

  def each_edge
    edge.each_next_edge
  end

  def eql?(face)
    vertices.eql?(face.vertices)
  end

  def hash
    vertices.hash
  end

  private
  attr_reader :edge

end
