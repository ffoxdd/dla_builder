require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/subdivider"
require_relative "../../../app/dcel/builder"

def test_vertex
  Object.new
end

describe DCEL::Subdivider do
  describe ".subdivide_triangle" do
    let(:vertices) { 3.times.map { test_vertex }}
    let(:inner_vertex) { test_vertex }

    it "subdivides a triangle about an interior vertex" do
      triangle = DCEL::Builder.triangle(vertices)
      perimeter_edges = triangle.edges

      new_triangles = DCEL::Subdivider.subdivide_triangle(triangle, inner_vertex)

      new_triangles.size.must_equal(3)
      # TODO: perform more thorough tests on the returned triangles

      perimeter_edges[0].must_be_face_for([vertices[0], vertices[1], inner_vertex])
      perimeter_edges[1].must_be_face_for([vertices[1], vertices[2], inner_vertex])
      perimeter_edges[2].must_be_face_for([vertices[2], vertices[0], inner_vertex])
      perimeter_edges[0].opposite_edge.must_be_face_for([vertices[1], vertices[0], vertices[2]])
    end
  end
end
