require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/half_edge"
require_relative "../../../app/dcel/builder"

def test_vertex
  Object.new
end

def test_half_edge
  DCEL::HalfEdge.new(origin_vertex: test_vertex)
end

def test_triangle
  DCEL::HalfEdge.singleton(origin_vertex: test_vertex).tap do |half_edge|
    half_edge.link_vertex(test_vertex)
    half_edge.next_half_edge.link_vertex(test_vertex)
  end
end

describe DCEL::HalfEdge do

  describe "#next_half_edge/#previous_half_edge/#twin_half_edge/#origin_vertex" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_half_edge = test_half_edge
      next_half_edge = test_half_edge
      twin_half_edge = test_half_edge

      half_edge = DCEL::HalfEdge.new(
        origin_vertex: origin_vertex,
        previous_half_edge: previous_half_edge,
        next_half_edge: next_half_edge,
        twin_half_edge: twin_half_edge
      )

      half_edge.origin_vertex.must_equal(origin_vertex)
      half_edge.previous_half_edge.must_equal(previous_half_edge)
      half_edge.next_half_edge.must_equal(next_half_edge)
      half_edge.twin_half_edge.must_equal(twin_half_edge)
    end
  end

  describe "#destination_vertex" do
    # TODO
  end

  describe "#adjacent_half_edge" do
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
      half_edges = triangle.half_edges

      half_edges.map(&:origin_vertex).must_equal(vertices)
      half_edges.must_form_a_half_edge_cycle

      twin_half_edges = half_edges.map(&:twin_half_edge)
      twin_half_edges.map(&:origin_vertex).must_equal([vertices[1], vertices[2], vertices[0]])
      twin_half_edges.reverse.must_form_a_half_edge_cycle
    end
  end

end
