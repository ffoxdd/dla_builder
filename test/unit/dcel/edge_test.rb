require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/edge"
require_relative "../../../app/dcel/builder"

def test_edge
  DCEL::Edge.new(origin_vertex: test_vertex)
end

def test_triangle
  DCEL::Edge.singleton(origin_vertex: test_vertex).tap do |edge|
    edge.link_vertex(test_vertex)
    edge.next_edge.link_vertex(test_vertex)
  end
end

describe DCEL::Edge do

  describe "#next_edge/#previous_edge/#opposite_edge/#origin_vertex" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_edge = test_edge
      next_edge = test_edge
      opposite_edge = test_edge

      edge = DCEL::Edge.new(
        origin_vertex: origin_vertex,
        previous_edge: previous_edge,
        next_edge: next_edge,
        opposite_edge: opposite_edge
      )

      edge.origin_vertex.must_equal(origin_vertex)
      edge.previous_edge.must_equal(previous_edge)
      edge.next_edge.must_equal(next_edge)
      edge.opposite_edge.must_equal(opposite_edge)
    end
  end

  describe "#destination_vertex" do
    # TODO
  end

  describe "#adjacent_edge" do
    # TODO
  end

  describe ".triangle" do
    it "raises ArgumentError when given less than 3 vertices" do
      proc { DCEL::Builder.triangle(2.times.map { test_vertex }) }.must_raise(ArgumentError)
    end

    it "raises ArgumentError when given more than 3 vertices" do
      proc { DCEL::Builder.triangle(4.times.map { test_vertex }) }.must_raise(ArgumentError)
    end

    it "creates a fully linked triangle from 3 vertices" do
      vertices = 3.times.map { test_vertex }

      triangle = DCEL::Builder.triangle(vertices)
      edges = triangle.edges

      edges.map(&:origin_vertex).must_equal(vertices)
      edges.must_form_a_edge_cycle

      opposite_edges = edges.map(&:opposite_edge)
      opposite_edges.map(&:origin_vertex).must_equal([vertices[1], vertices[2], vertices[0]])
      opposite_edges.reverse.must_form_a_edge_cycle
    end
  end

end
