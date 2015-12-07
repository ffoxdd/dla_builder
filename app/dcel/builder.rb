require_relative "edge"
require_relative "face"

module DCEL; end

module DCEL::Builder
  extend self

  def polygon(vertices)
    inner_edges = vertices.map { |vertex| new_edge(vertex) }
    inner_face = DCEL::Face.build_from_edges(inner_edges)

    outer_edges = inner_edges.map { |edge| new_opposite_edge(edge) }.reverse
    outer_face = DCEL::Face.build_from_edges(outer_edges)

    inner_face
  end

  def link_sequentially(previous_edge, next_edge) # TODO: kill this method
    DCEL::Edge.link(previous_edge, next_edge)
  end

  def link_opposite(edge, opposite_edge)
    edge.opposite_edge = opposite_edge
    opposite_edge.opposite_edge = edge
  end

  private

  def new_opposite_edge(edge)
    new_edge(edge.destination_vertex).tap { |opposite_edge| link_opposite(edge, opposite_edge) }
  end

  def new_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex)
  end
end
