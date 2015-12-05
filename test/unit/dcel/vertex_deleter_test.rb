require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/vertex_deleter"
require_relative "../../../app/dcel/subdivider"
require_relative "../../../app/dcel/builder"

def test_vertex
  Object.new
end

describe DCEL::VertexDeleter do
  describe "#delete_vertex" do
    let(:vertices) { 3.times.map { test_vertex } }
    let(:inner_vertex) { test_vertex }
    let(:triangle) { DCEL::Builder.triangle(vertices) }
    let(:original_triangle_edges) { triangle.edges }

    before do
      original_triangle_edges
      DCEL::Subdivider.new(triangle, inner_vertex).subdivide_triangle
    end

    it "can delete an inner vertex" do
      inner_vertex_edge = original_triangle_edges[0].previous_edge
      DCEL::VertexDeleter.new.delete_vertex(inner_vertex_edge)

      inner_edge = original_triangle_edges[0]

      inner_edge.must_be_face_for(vertices)
      inner_edge.twin_edge.must_be_face_for([vertices[1], vertices[0], vertices[2]])
    end

    it "can delete a perimeter vertex" do
      perimeter_vertex_edge = original_triangle_edges[0].twin_edge
      DCEL::VertexDeleter.new.delete_vertex(perimeter_vertex_edge)

      inner_edge = original_triangle_edges[2]

      inner_edge.must_be_face_for([vertices[2], vertices[0], inner_vertex])
      inner_edge.twin_edge.must_be_face_for([vertices[0], vertices[2], inner_vertex])
    end
  end
end
