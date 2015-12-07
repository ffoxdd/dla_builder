require_relative "edge"
require_relative "face"

module DCEL; end

module DCEL::Builder
  extend self

  def face(vertices)
    edges = vertices.map { |vertex| new_edge(vertex) }
    cyclically_link(edges)

    opposite_edges = edges.map { |edge| new_edge(edge.destination_vertex) }
    cyclically_link(opposite_edges.reverse)

    link_opposites(edges, opposite_edges)

    DCEL::Face.new(edges.first).tap { |face| set_face(edges, face) }
  end

  def set_face(edges, face)
    edges.each { |edge| edge.left_face = face }
  end

  def cyclically_link(edges)
    DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
      link_sequentially(previous_edge, next_edge)
    end
  end

  def link_opposites(edges, opposite_edges)
    edges.zip(opposite_edges).each do |edge, opposite_edge|
      link_opposite(edge, opposite_edge)
    end
  end

  def link_sequentially(previous_edge, next_edge)
    previous_edge.next_edge = next_edge
    next_edge.previous_edge = previous_edge
  end

  def link_opposite(edge, opposite_edge)
    edge.opposite_edge = opposite_edge
    opposite_edge.opposite_edge = edge
  end

  private

  def new_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex)
  end
end
