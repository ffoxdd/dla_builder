require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/half_edge"

def test_vertex
  Object.new
end

describe DCEL::HalfEdge do

  describe "#next/#previous/#twin/#origin" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_half_edge = DCEL::HalfEdge.new(origin: test_vertex)
      next_half_edge = DCEL::HalfEdge.new(origin: test_vertex)
      twin_half_edge = DCEL::HalfEdge.new(origin: test_vertex)

      edge = DCEL::HalfEdge.new(
        origin: origin_vertex, previous: previous_half_edge, next: next_half_edge, twin: twin_half_edge
      )

      edge.origin.must_equal(origin_vertex)
      edge.previous.must_equal(previous_half_edge)
      edge.next.must_equal(next_half_edge)
      edge.twin.must_equal(twin_half_edge)
    end
  end

  describe "#link_next/#link_previous" do
    let(:half_edge_1) { DCEL::HalfEdge.new(origin: test_vertex) }
    let(:half_edge_2) { DCEL::HalfEdge.new(origin: test_vertex) }

    it "creates a link to the next edge" do
      half_edge_1.link_next(half_edge_2)

      half_edge_1.next.must_equal(half_edge_2)
      half_edge_2.previous.must_equal(half_edge_1)
    end

    it "creates a link to the previous edge" do
      half_edge_1.link_previous(half_edge_2)

      half_edge_1.previous.must_equal(half_edge_2)
      half_edge_2.next.must_equal(half_edge_1)
    end
  end

end
