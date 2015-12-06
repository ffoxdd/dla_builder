require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/builder"

describe DCEL::Builder do
  describe ".triangle" do
    it "raises ArgumentError when given fewer than 3 vertices" do
      vertices = 2.times.map { test_vertex }
      proc { DCEL::Builder.triangle(vertices) }.must_raise(ArgumentError)
    end

    it "raises ArgumentError when given more than 3 vertices" do
      vertices = 4.times.map { test_vertex }
      proc { DCEL::Builder.triangle(vertices) }.must_raise(ArgumentError)
    end

    it "creates a fully linked triangle from 3 vertices" do
      vertices = 3.times.map { test_vertex }

      face = DCEL::Builder.triangle(vertices)
      edges = face.edges

      face.edges.must_form_a_edge_cycle

      edges.map(&:origin_vertex).must_equal(vertices)

      opposite_edges = edges.map(&:opposite_edge)
      opposite_edges.map(&:origin_vertex).must_equal([vertices[1], vertices[2], vertices[0]])
      opposite_edges.reverse.must_form_a_edge_cycle
    end
  end

end
