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
    yield(deleted_faces, deleted_edges, deleted_vertex, new_face) if block_given?
  end

  private
  attr_reader :deleted_edge

  def deleted_vertex
    deleted_edge.origin_vertex
  end

  def deleted_faces
    deleted_edge.each_adjacent_face.to_a
  end

  def adjacent_edges
    @adjacent_edges ||= deleted_edge.each_adjacent_edge.to_a
  end

  def deleted_edges
    adjacent_edges + adjacent_edges.map(&:opposite_edge)
  end

  def new_face
    @new_face ||= DCEL::Face.from_connected_edge(deleted_edge.next_edge)
  end

  def delete_edge(edge)
    DCEL::Edge.link(*new_corner_edges(edge))
  end

  def new_corner_edges(edge)
    # TODO: make an edge method for edge.opposite_edge.previous_edge
    [edge.opposite_edge.previous_edge, edge.next_edge]
  end
end
