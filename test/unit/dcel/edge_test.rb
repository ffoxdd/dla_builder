require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/edge"
require_relative "../../../app/dcel/builder"

def test_edge
  DCEL::Edge.new(origin_vertex: test_vertex)
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

  describe "#includes_vertex" do
    # TODO
  end

  describe "#adjacent_edge" do
    # TODO
  end

end
