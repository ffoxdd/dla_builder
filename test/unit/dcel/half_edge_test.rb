require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/half_edge"

def test_vertex
  Object.new
end

def test_half_edge
  DCEL::HalfEdge.new(origin: test_vertex)
end

def test_triangle
  DCEL::HalfEdge.singleton(origin: test_vertex).tap do |half_edge|
    half_edge.link_vertex(test_vertex)
    half_edge.next_half_edge.link_vertex(test_vertex)
  end
end

describe DCEL::HalfEdge do

  describe "#next_half_edge/#previous_half_edge/#twin_half_edge/#origin" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_half_edge = test_half_edge
      next_half_edge = test_half_edge
      twin_half_edge = test_half_edge

      half_edge = DCEL::HalfEdge.new(
        origin: origin_vertex,
        previous_half_edge: previous_half_edge,
        next_half_edge: next_half_edge,
        twin_half_edge: twin_half_edge
      )

      half_edge.origin.must_equal(origin_vertex)
      half_edge.previous_half_edge.must_equal(previous_half_edge)
      half_edge.next_half_edge.must_equal(next_half_edge)
      half_edge.twin_half_edge.must_equal(twin_half_edge)
    end
  end

  describe ".triangle" do
    # TODO: make a matcher to check that an array of half edges are circularly linked

    it "raises ArgumentError when given less than 3 vertices" do
      proc { DCEL::HalfEdge.triangle(2.times.map { test_vertex }) }.must_raise(ArgumentError)
    end

    it "raises ArgumentError when given more than 3 vertices" do
      proc { DCEL::HalfEdge.triangle(4.times.map { test_vertex }) }.must_raise(ArgumentError)
    end

    it "creates a fully linked triangle from 3 vertices" do
      vertices = 3.times.map { test_vertex }

      half_edge_0 = DCEL::HalfEdge.triangle(vertices)
      half_edge_1 = half_edge_0.next_half_edge
      half_edge_2 = half_edge_1.next_half_edge

      half_edge_0.origin.must_equal(vertices[0])
      half_edge_1.origin.must_equal(vertices[1])
      half_edge_2.origin.must_equal(vertices[2])

      half_edge_0.next_half_edge.must_equal(half_edge_1)
      half_edge_1.next_half_edge.must_equal(half_edge_2)
      half_edge_2.next_half_edge.must_equal(half_edge_0)

      half_edge_0.previous_half_edge.must_equal(half_edge_2)
      half_edge_1.previous_half_edge.must_equal(half_edge_0)
      half_edge_2.previous_half_edge.must_equal(half_edge_1)

      twin_half_edge_0 = half_edge_0.twin_half_edge
      twin_half_edge_1 = half_edge_1.twin_half_edge
      twin_half_edge_2 = half_edge_2.twin_half_edge

      twin_half_edge_0.origin.must_equal(vertices[1])
      twin_half_edge_1.origin.must_equal(vertices[2])
      twin_half_edge_2.origin.must_equal(vertices[0])

      twin_half_edge_0.next_half_edge.must_equal(twin_half_edge_2)
      twin_half_edge_1.next_half_edge.must_equal(twin_half_edge_0)
      twin_half_edge_2.next_half_edge.must_equal(twin_half_edge_1)

      twin_half_edge_0.previous_half_edge.must_equal(twin_half_edge_1)
      twin_half_edge_1.previous_half_edge.must_equal(twin_half_edge_2)
      twin_half_edge_2.previous_half_edge.must_equal(twin_half_edge_0)
    end
  end

end
