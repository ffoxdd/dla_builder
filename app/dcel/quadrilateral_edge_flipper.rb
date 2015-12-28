require_relative "dcel"
require_relative "edge"
require_relative "face"
require_relative "face_builder"

class DCEL::QuadrilateralEdgeFlipper

  def self.flip(edge, &block)
    new(edge).flip(&block)
  end

  def initialize(edge)
    @left_edge = edge
    @right_edge = edge.opposite_edge

    perimeter_edge_0 = @left_edge.next_edge
    perimeter_edge_1 = @left_edge.previous_edge
    perimeter_edge_2 = @right_edge.next_edge
    perimeter_edge_3 = @right_edge.previous_edge

    @perimeter_edges = [perimeter_edge_0, perimeter_edge_1, perimeter_edge_2, perimeter_edge_3]
    @perimeter_vertices = @perimeter_edges.map(&:origin_vertex)
  end

  def flip
    removed_faces = [left_edge.left_face, right_edge.left_face]

    left_edge.origin_vertex = perimeter_vertices[1]
    right_edge.origin_vertex = perimeter_vertices[3]

    set_origin_vertex_edge_reference(perimeter_edges[2])
    set_origin_vertex_edge_reference(perimeter_edges[0])

    added_faces = [
      DCEL::FaceBuilder.face([left_edge, perimeter_edges[3], perimeter_edges[0]]),
      DCEL::FaceBuilder.face([right_edge, perimeter_edges[1], perimeter_edges[2]])
    ]

    affected_edges = perimeter_edges

    yield(removed_faces, added_faces, affected_edges) if block_given?

    left_edge
  end

  private
  attr_reader :left_edge, :right_edge, :perimeter_edges, :perimeter_vertices

  def set_origin_vertex_edge_reference(edge)
    edge.origin_vertex.edge = edge
  end

end
