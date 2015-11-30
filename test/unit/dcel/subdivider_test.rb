require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/subdivider"
require_relative "../../../app/dcel/builder"

def test_vertex
  Object.new
end

describe DCEL::Subdivider do
  describe "#subdivide_triangle" do
    it "subdivides a triangle about an interior vertex" do
      vertices = 3.times.map { test_vertex }
      inner_vertex = test_vertex
      triangle = DCEL::Builder.triangle(vertices)
      half_edges = triangle.half_edges

      DCEL::Subdivider.new(half_edges[0], inner_vertex).subdivide_triangle

      half_edges[0].must_be_face_for([vertices[0], vertices[1], inner_vertex])
      half_edges[1].must_be_face_for([vertices[1], vertices[2], inner_vertex])
      half_edges[2].must_be_face_for([vertices[2], vertices[0], inner_vertex])

      half_edges[0].twin_half_edge.must_be_face_for([vertices[1], vertices[0], vertices[2]])
    end
  end
end
