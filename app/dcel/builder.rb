require_relative "half_edge"
require_relative "face"

module DCEL; end

module DCEL::Builder
  extend self

  def triangle(vertices)
    raise ArgumentError unless vertices.size == 3

    half_edges = vertices.map { |vertex| new_half_edge(vertex) }
    cyclically_link(half_edges)

    twin_half_edges = half_edges.map { |half_edge| new_half_edge(half_edge.next_vertex) }
    cyclically_link(twin_half_edges.reverse)

    link_twins(half_edges, twin_half_edges)

    DCEL::Face.new(half_edges.first)
  end

  def cyclically_link(half_edges)
    DCEL.cyclical_each_pair(half_edges) do |previous_half_edge, next_half_edge|
      link_sequentially(previous_half_edge, next_half_edge)
    end
  end

  def link_twins(half_edges, twin_half_edges)
    half_edges.zip(twin_half_edges).each do |half_edge, twin_half_edge|
      link_twin(half_edge, twin_half_edge)
    end
  end

  def link_sequentially(previous_half_edge, next_half_edge)
    previous_half_edge.next_half_edge = next_half_edge
    next_half_edge.previous_half_edge = previous_half_edge
  end

  def link_twin(half_edge, twin_half_edge)
    half_edge.twin_half_edge = twin_half_edge
    twin_half_edge.twin_half_edge = half_edge
  end

  private

  def new_half_edge(vertex)
    DCEL::HalfEdge.new(origin: vertex)
  end
end
