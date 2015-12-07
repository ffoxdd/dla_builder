require_relative "edge"
require_relative "face"

module DCEL; end

module DCEL::Builder
  extend self

  def face(vertices)
    inner_edges = vertices.map { |vertex| new_edge(vertex) }
    cyclically_link(inner_edges)

    outer_edges = inner_edges.map { |edge| new_edge(edge.destination_vertex) }
    cyclically_link(outer_edges.reverse)

    link_opposites(inner_edges, outer_edges)

    inner_face = DCEL::Face.new(inner_edges.first)
    outer_face = DCEL::Face.new(outer_edges.first)

    set_face(inner_edges, inner_face)
    set_face(outer_edges, outer_face)

    inner_face
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
