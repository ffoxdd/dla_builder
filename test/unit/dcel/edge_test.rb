require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/edge"
require_relative "../../../app/point"
require_relative "../../../app/ray"

def test_edge
  DCEL::Edge.new(origin_vertex: test_vertex)
end

def edge_from_endpoints(origin_vertex, destination_vertex)
  DCEL::Edge.new(origin_vertex: origin_vertex).tap do |edge|
    next_edge = DCEL::Edge.new(origin_vertex: destination_vertex)
    DCEL::Edge.link(edge, next_edge)
  end
end

describe DCEL::Edge do

  describe ".link" do
    # TODO
  end

  describe ".link_opposites" do
    # TODO
  end

  describe "#next_edge/#previous_edge/#opposite_edge/#origin_vertex/#left_face" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_edge = test_edge
      next_edge = test_edge
      opposite_edge = test_edge
      left_face = Object.new

      edge = DCEL::Edge.new(
        origin_vertex: origin_vertex,
        previous_edge: previous_edge,
        next_edge: next_edge,
        opposite_edge: opposite_edge,
        left_face: left_face
      )

      edge.origin_vertex.must_equal(origin_vertex)
      edge.previous_edge.must_equal(previous_edge)
      edge.next_edge.must_equal(next_edge)
      edge.opposite_edge.must_equal(opposite_edge)
      edge.left_face.must_equal(left_face)
    end
  end

  describe "#destination_vertex" do
    # TODO
  end

  describe "#adjacent_edge" do
    # TODO
  end

  describe "#right_face" do
    # TODO
  end

  describe "#each_adjacent_edge_enumerator" do
    # TODO
  end

  describe "#each_next_edge" do
    # TODO
  end

  describe "#each_adjacent_face" do
    # TODO
  end

  describe "#eql?/hash" do
    let(:origin_vertex) { test_vertex }
    let(:destination_vertex) { test_vertex }
    let(:different_vertex) { test_vertex }

    it "represent equality if they have the same endpoints" do
      edge_0 = edge_from_endpoints(origin_vertex, destination_vertex)
      edge_1 = edge_from_endpoints(origin_vertex, destination_vertex)

      edge_0.eql?(edge_1).must_equal(true)
      edge_0.hash.must_equal(edge_1.hash)
    end

    it "doesn't represent equality if the endpoints are different" do
      edge_0 = edge_from_endpoints(origin_vertex, destination_vertex)
      edge_1 = edge_from_endpoints(origin_vertex, different_vertex)

      edge_0.eql?(edge_1).must_equal(false)
      edge_0.hash.wont_equal(edge_1.hash)
    end
  end

end
