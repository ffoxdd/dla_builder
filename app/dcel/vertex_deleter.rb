module DCEL; end

class DCEL::VertexDeleter

  def self.delete_vertex(edge, &block)
    new(edge).delete_vertex(&block)
  end

  def initialize(deleted_vertex)
    @deleted_vertex = deleted_vertex
    @new_edges = []
  end

  def delete_vertex(&block)
    delete_adjacent_edges
    yield(new_faces, deleted_faces, new_edges, deleted_edges, deleted_vertex) if block_given?
  end

  private
  attr_reader :deleted_vertex, :new_edges

  def delete_adjacent_edges
    adjacent_edges.each { |edge| delete_edge(edge) }
    adjust_destination_vertex_edge_references
  end

  def deleted_faces
    deleted_vertex.adjacent_face_enumerator.to_a
  end

  def adjacent_edges
    @adjacent_edges ||= deleted_vertex.adjacent_edge_enumerator.to_a
  end

  def deleted_edges
    @deleted_edges ||= adjacent_edges + adjacent_edges.map(&:opposite_edge)
  end

  def new_faces
    @new_faces ||= begin
      new_face_edge = adjacent_edges.first.next_edge
      return [] if deleted_edges.include?(new_face_edge)
      [DCEL::Face.from_connected_edge(new_face_edge)]
    end
  end

  def delete_edge(edge)
    # adjust_vertex_edge_reference(edge.destination_vertex)
    DCEL::Edge.link(*new_corner_edges(edge))
  end

  def adjust_destination_vertex_edge_references
    adjacent_edges.each { |edge| adjust_vertex_edge_reference(edge.destination_vertex) }
  end

  def adjacent_destination_vertices
    adjacent_edges.map(&:destination_vertex).uniq
  end

  def adjust_vertex_edge_reference(vertex)
    return if vertex == deleted_vertex
    vertex.edge = not_deleted_edge(vertex) || self_edge(vertex)
  end

  def self_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex).tap do |edge|
      DCEL::Edge.link(edge, edge)
      DCEL::Edge.link_opposites(edge, edge)
      @new_edges = [edge]
      @new_faces = [edge.left_face = DCEL::Face.new(edge)]
    end
  end

  def not_deleted_edge(vertex)
    vertex.adjacent_edge_enumerator.find { |edge| !deleted_edges.include?(edge) }
  end

  def new_corner_edges(edge)
    [edge.opposite_edge.previous_edge, edge.next_edge]
  end
end
