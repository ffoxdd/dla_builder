require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/vertex_deleter"
require_relative "../../../app/dcel/face_subdivider"
require_relative "../../../app/dcel/polygon_builder"

describe DCEL::VertexDeleter do
  describe "#delete_vertex" do
    let(:original_vertices) { 3.times.map { test_vertex } }
    let(:inner_vertex) { test_vertex }
    let(:inner_face) { DCEL::PolygonBuilder.polygon(original_vertices) }

    attr_reader :outer_edge, :inner_edge

    before do
      outer_edges = inner_face.edges
      DCEL::FaceSubdivider.subdivide_face(inner_face, inner_vertex)

      @outer_edge = outer_edges.first
      @inner_edge = @outer_edge.previous_edge
    end

    it "can delete an inner vertex" do
      old_face = outer_edge.left_face

      DCEL::VertexDeleter.delete_vertex(inner_edge) do |deleted_faces, deleted_edges, deleted_vertex|
        new_face = outer_edge.left_face
        new_face.wont_equal(old_face)
        new_face.vertices.must_cyclically_equal(original_vertices)

        deleted_faces.size.must_equal(3)
        deleted_edges.size.must_equal(6)
        deleted_vertex.must_equal(inner_vertex)
      end
    end

    it "can delete a perimeter vertex" do
      new_outer_edge = outer_edge.next_edge

      DCEL::VertexDeleter.delete_vertex(outer_edge) do |deleted_faces, deleted_edges, deleted_vertex|
        new_face = new_outer_edge.left_face
        new_triangle_vertices = [original_vertices[1], inner_vertex, original_vertices[2]]

        new_face.vertices.must_cyclically_equal(new_triangle_vertices)

        deleted_faces.size.must_equal(3)
        deleted_edges.size.must_equal(6)
        deleted_vertex.must_equal(outer_edge.origin_vertex)
      end
    end
  end
end
