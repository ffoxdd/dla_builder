require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/half_edge"

def test_vertex
  Object.new
end

def test_half_edge
  DCEL::HalfEdge.new(origin: test_vertex)
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

  describe ".degenerate" do
    it "creates a half-edge whose twin points to the same vertex" do
      vertex = Object.new
      half_edge = DCEL::HalfEdge.degenerate(origin: vertex)

      half_edge.twin_half_edge.wont_equal(nil)
      half_edge.twin_half_edge.origin.must_equal(half_edge.origin)
    end
  end

  describe "#link_vertex" do
    it "links a degenerate half-edge to a new vertex" do
      half_edge = DCEL::HalfEdge.degenerate(origin: Object.new)
      next_vertex = Object.new

      half_edge.link_vertex(next_vertex)

      half_edge.next_half_edge.wont_equal(nil)
      half_edge.next_half_edge.origin.must_equal(next_vertex)
      half_edge.twin_half_edge.origin.must_equal(next_vertex)

      half_edge.next_half_edge.twin_half_edge.wont_equal(nil)
      half_edge.next_half_edge.twin_half_edge.origin.must_equal(next_vertex) # self-twin
    end

    it "links a connected half-edge by connecting a new triangle" do
      half_edge_0 = DCEL::HalfEdge.degenerate(origin: Object.new)
      half_edge_0.link_vertex(Object.new)

      half_edge = half_edge_0.next_half_edge
      next_vertex = Object.new

      half_edge.link_vertex(next_vertex)

      half_edge.next_half_edge.wont_equal(nil)
      half_edge.next_half_edge.origin.must_equal(next_vertex)
      half_edge.twin_half_edge.origin.must_equal(next_vertex)

      half_edge.next_half_edge.twin_half_edge.wont_equal(nil)
      half_edge.next_half_edge.twin_half_edge.origin.must_equal(half_edge_0.origin) # triangle
    end
  end

end
