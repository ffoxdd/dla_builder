require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/builder"

describe DCEL::Builder do
  describe ".face" do
    let(:vertices) { 3.times.map { test_vertex }}

    it "creates a fully linked face" do
      face = DCEL::Builder.face(vertices)
      face.vertices.must_equal(vertices)

      inner_edges = face.edges
      inner_edges.must_form_a_edge_cycle

      outer_edges = inner_edges.map(&:opposite_edge)
      outer_edges.map(&:origin_vertex).must_equal([vertices[1], vertices[2], vertices[0]])
      outer_edges.reverse.must_form_a_edge_cycle

      inner_edges.each { |edge| edge.left_face.must_equal(face) }

      outer_face = outer_edges.first.left_face
      outer_edges.each { |edge| edge.left_face.must_equal(outer_face) }
    end
  end

end
