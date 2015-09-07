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

  describe "#triangle?" do
    it "returns false when the half edge is part of a degenerate mesh" do

    end

    it "returns true when the half edge is part of a closed triangle" do
      half_edge_0 = test_half_edge
      half_edge_1 = test_half_edge
      half_edge_2 = test_half_edge

      half_edge_0.link_next(half_edge_1)
      half_edge_1.link_next(half_edge_2)
      half_edge_2.link_next(half_edge_0)

      half_edge_0.triangle?.must_equal(true)
    end

    it "returns false when the half edge is part of the mesh perimeter" do
    end
  end

  describe "#link_next" do
    it "creates a link to the next half edge and updates any other immediate linkages" do
      half_edge = test_half_edge
      twin_half_edge = test_half_edge
      old_next_half_edge = test_half_edge
      new_next_half_edge = test_half_edge

      half_edge.link_twin(twin_half_edge)
      half_edge.link_next(old_next_half_edge)

      half_edge.link_next(new_next_half_edge)

      half_edge.next_half_edge.must_equal(new_next_half_edge)
      twin_half_edge.origin.must_equal(new_next_half_edge.origin)
      old_next_half_edge.previous_half_edge.must_equal(nil)
    end
  end

  describe "#link_previous" do
    it "creates a link to the previous half edge and updates any other immediate linkages" do
      half_edge = test_half_edge
      old_previous_half_edge = test_half_edge
      new_previous_half_edge = test_half_edge
      new_previous_twin_half_edge = test_half_edge

      new_previous_half_edge.link_twin(new_previous_twin_half_edge)
      half_edge.link_previous(old_previous_half_edge)

      half_edge.link_previous(new_previous_half_edge)

      half_edge.previous_half_edge.must_equal(new_previous_half_edge)
      new_previous_twin_half_edge.origin.must_equal(half_edge.origin)
      old_previous_half_edge.next_half_edge.must_equal(nil)
    end
  end

  # describe "#link_twin" do
  #   it "creates a link to the twin half edge and updates any other immediate linkages" do
  #   end
  # end

  # describe "#each_perimeter" do
  #   it "iterates over all perimeter half edges" do
  #     half_edge_1 = test_half_edge
  #     half_edge_2 = test_half_edge
  #     half_edge_3 = test_half_edge
  #
  #     half_edge_1.link_next(half_edge_2)
  #     half_edge_2.link_next(half_edge_3)
  #     half_edge_3.link_next(half_edge_1)
  #
  #     half_edge_1.each_perimeter.to_a.must_cyclically_equal [half_edge_1, half_edge_2, half_edge_3]
  #   end
  #
  #   it "ignores inner linkages" do
  #     #    2
  #     #  / | \
  #     # 0  |  3
  #     #  \ | /
  #     #    1
  #
  #     vertices = 4.times.map { Object.new }
  #
  #     e_0_1 = DCEL::HalfEdge.new(origin: vertices[0])
  #     e_1_0 = DCEL::HalfEdge.new(origin: vertices[1])
  #
  #     e_1_2 = DCEL::HalfEdge.new(origin: vertices[1])
  #     e_2_1 = DCEL::HalfEdge.new(origin: vertices[2])
  #
  #     e_2_0 = DCEL::HalfEdge.new(origin: vertices[2])
  #     e_0_2 = DCEL::HalfEdge.new(origin: vertices[0])
  #
  #     e_1_3 = DCEL::HalfEdge.new(origin: vertices[1])
  #     e_3_1 = DCEL::HalfEdge.new(origin: vertices[3])
  #
  #     e_3_2 = DCEL::HalfEdge.new(origin: vertices[3])
  #     e_2_3 = DCEL::HalfEdge.new(origin: vertices[2])
  #
  #     e_0_1.link_twin(e_1_0)
  #     e_1_2.link_twin(e_2_1)
  #     e_2_0.link_twin(e_0_2)
  #     e_1_3.link_twin(e_3_1)
  #     e_3_2.link_twin(e_2_3)
  #   end
  # end

end
