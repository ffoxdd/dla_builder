require_relative "edge"
require_relative "face"

module DCEL; end

module DCEL::Builder
  extend self

  def triangle(vertices)
    raise ArgumentError unless vertices.size == 3

    edges = vertices.map { |vertex| new_edge(vertex) }
    cyclically_link(edges)

    twin_edges = edges.map { |edge| new_edge(edge.destination_vertex) }
    cyclically_link(twin_edges.reverse)

    link_twins(edges, twin_edges)

    DCEL::Face.new(edges.first)
  end

  def cyclically_link(edges)
    DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
      link_sequentially(previous_edge, next_edge)
    end
  end

  def link_twins(edges, twin_edges)
    edges.zip(twin_edges).each do |edge, twin_edge|
      link_twin(edge, twin_edge)
    end
  end

  def link_sequentially(previous_edge, next_edge)
    previous_edge.next_edge = next_edge
    next_edge.previous_edge = previous_edge
  end

  def link_twin(edge, twin_edge)
    edge.twin_edge = twin_edge
    twin_edge.twin_edge = edge
  end

  private

  def new_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex)
  end
end
