require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/vertex_deleter"
require_relative "../../../app/dcel/face_subdivider"
require_relative "../../../app/dcel/cycle_graph_builder"

describe DCEL::VertexDeleter do
  describe "#delete_vertex" do
    let(:vertex_values) { 3.times.map { test_vertex } }
    let(:inner_vertex_value) { test_vertex }
    let(:inner_face) { DCEL::CycleGraphBuilder.cycle_graph(vertex_values) }

    attr_reader :outer_edge, :inner_edge, :old_face, :inner_vertex, :outer_vertex

    before do
      outer_edges = inner_face.edge_enumerator.to_a

      DCEL::FaceSubdivider.subdivide_face(inner_face, inner_vertex_value) do |_, _, new_vertex|
        @inner_vertex = new_vertex
      end

      @outer_edge = outer_edges.first
      @outer_vertex = @outer_edge.origin_vertex
      @inner_edge = @outer_edge.previous_edge
      @old_face = @outer_edge.left_face
    end

    it "can delete an inner vertex" do
      DCEL::VertexDeleter.delete_vertex(inner_vertex) do |(new_face), deleted_faces, new_edges, deleted_edges, deleted_vertex|
        # note that the deleted faces are corrupt and cannot be iterated over

        deleted_faces.size.must_equal(3)
        deleted_edges.size.must_equal(6)
        deleted_vertex.value.must_equal(inner_vertex_value)

        # TODO: test deleted elements more thoroughly

        new_face.vertex_value_enumerator.to_a.must_cyclically_equal(vertex_values)
      end
    end

    it "can delete a perimeter vertex" do
      new_outer_edge = outer_edge.next_edge

      DCEL::VertexDeleter.delete_vertex(outer_edge) do |(new_face), deleted_faces, new_edges, deleted_edges, deleted_vertex|
        # note that the deleted faces are corrupt and cannot be iterated over

        deleted_faces.size.must_equal(3)
        deleted_edges.size.must_equal(6)

        # TODO: test deleted elements more thoroughly

        new_triangle_vertex_values = [vertex_values[1], inner_vertex_value, vertex_values[2]]
        new_face.vertex_value_enumerator.to_a.must_cyclically_equal(new_triangle_vertex_values)
      end
    end
  end
end
