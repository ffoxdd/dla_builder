require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/builder"

describe DCEL::Builder do
  describe ".face" do
    let(:vertices) { 3.times.map { test_vertex }}

    it "creates a fully linked face" do
      face = DCEL::Builder.face(vertices)

      edges = face.edges
      edges.must_form_a_edge_cycle

      opposite_edges = edges.map(&:opposite_edge)
      opposite_edges.map(&:origin_vertex).must_equal([vertices[1], vertices[2], vertices[0]])
      opposite_edges.reverse.must_form_a_edge_cycle

      face.vertices.must_equal(vertices)
    end
  end

end
