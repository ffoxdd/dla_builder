require_relative "edge"
require_relative "face"

module DCEL; end

module DCEL::PolygonBuilder
  extend self

  def polygon(vertices)
    inner_edges = vertices.map { |vertex| new_edge(vertex) }
    inner_face = DCEL::Face.build_from_edges(inner_edges)

    outer_edges = inner_edges.map { |edge| new_opposite_edge(edge) }.reverse
    outer_face = DCEL::Face.build_from_edges(outer_edges)

    inner_face
  end

  private

  def new_opposite_edge(edge)
    new_edge(edge.destination_vertex).tap do |opposite_edge|
      DCEL::Edge.link_opposites(edge, opposite_edge)
    end
  end

  def new_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex)
  end
end
