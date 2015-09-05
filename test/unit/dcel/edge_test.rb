require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/edge"

def test_vertex
  Object.new
end

describe DCEL::Edge do

  describe "#next/#previous/#twin/#origin" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_edge = DCEL::Edge.new(origin: test_vertex)
      next_edge = DCEL::Edge.new(origin: test_vertex)
      twin_edge = DCEL::Edge.new(origin: test_vertex)

      edge = DCEL::Edge.new(
        origin: origin_vertex, previous: previous_edge, next: next_edge, twin: twin_edge
      )

      edge.origin.must_equal(origin_vertex)
      edge.previous.must_equal(previous_edge)
      edge.next.must_equal(next_edge)
      edge.twin.must_equal(twin_edge)
    end
  end

  describe "#link_next/#link_previous" do
    let(:edge_1) { DCEL::Edge.new(origin: test_vertex) }
    let(:edge_2) { DCEL::Edge.new(origin: test_vertex) }

    it "creates a link to the next edge" do
      edge_1.link_next(edge_2)

      edge_1.next.must_equal(edge_2)
      edge_2.previous.must_equal(edge_1)
    end

    it "creates a link to the previous edge" do
      edge_1.link_previous(edge_2)

      edge_1.previous.must_equal(edge_2)
      edge_2.next.must_equal(edge_1)
    end
  end

end
