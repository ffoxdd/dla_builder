require_relative "builder"

module DCEL; end

class DCEL::VertexDeleter

  def self.delete_vertex(edge, &block)
    new(edge).delete_vertex(&block)
  end

  def initialize(deleted_edge)
    @deleted_edge = deleted_edge
  end

  def delete_vertex(&block)
    adjacent_edges.each { |edge| delete_edge(edge) }
    yield(nil, deleted_edges, deleted_vertex) if block_given?
  end

  private
  attr_reader :deleted_edge

  def deleted_vertex
    deleted_edge.origin_vertex
  end

  def adjacent_edges
    @adjacent_edges ||= deleted_edge.all_adjacent_edges
  end

  def deleted_edges
    adjacent_edges + adjacent_edges.map(&:opposite_edge)
  end

  def delete_edge(edge)
    DCEL::Builder.link_sequentially(*new_corner_edges(edge))
  end

  def new_corner_edges(edge)
    [edge.opposite_edge.previous_edge, edge.next_edge]
  end
end
