require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/half_edge"

def test_vertex
  Object.new
end

def test_half_edge
  DCEL::HalfEdge.new(origin: test_vertex)
end

describe DCEL::HalfEdge do

  describe "#next/#previous/#twin/#origin" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_half_edge = test_half_edge
      next_half_edge = test_half_edge
      twin_half_edge = test_half_edge

      edge = DCEL::HalfEdge.new(
        origin: origin_vertex, previous: previous_half_edge, next: next_half_edge, twin: twin_half_edge
      )

      edge.origin.must_equal(origin_vertex)
      edge.previous.must_equal(previous_half_edge)
      edge.next.must_equal(next_half_edge)
      edge.twin.must_equal(twin_half_edge)
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

      half_edge.next.must_equal(new_next_half_edge)
      old_next_half_edge.previous.must_equal(nil)
    end
  end

  # describe "#link_next/#link_previous/#link_twin" do
  #   let(:half_edge_1) { test_half_edge }
  #   let(:half_edge_2) { test_half_edge }
  #
  #   it "creates a link to the next half edge" do
  #     half_edge_1.link_next(half_edge_2)
  #
  #     half_edge_1.next.must_equal(half_edge_2)
  #     half_edge_2.previous.must_equal(half_edge_1)
  #   end
  #
  #   it "creates a link to the previous half edge" do
  #     half_edge_1.link_previous(half_edge_2)
  #
  #     half_edge_1.previous.must_equal(half_edge_2)
  #     half_edge_2.next.must_equal(half_edge_1)
  #   end
  #
  #   it "creates a link to the twin half edge" do
  #     half_edge_1.link_twin(half_edge_2)
  #
  #     half_edge_1.twin.must_equal(half_edge_2)
  #     half_edge_2.twin.must_equal(half_edge_1)
  #   end
  # end

  describe "#each_perimeter" do
    it "iterates over all perimeter half edges" do
      half_edge_1 = test_half_edge
      half_edge_2 = test_half_edge
      half_edge_3 = test_half_edge

      half_edge_1.link_next(half_edge_2)
      half_edge_2.link_next(half_edge_3)
      half_edge_3.link_next(half_edge_1)

      half_edge_1.each_perimeter.to_a.must_cyclically_equal [half_edge_1, half_edge_2, half_edge_3]
    end

    it "ignores inner linkages" do
      #    2
      #  / | \
      # 0  |  3
      #  \ | /
      #    1

      vertices = 4.times.map { Object.new }

      e_0_1 = DCEL::HalfEdge.new(origin: vertices[0])
      e_1_0 = DCEL::HalfEdge.new(origin: vertices[1])

      e_1_2 = DCEL::HalfEdge.new(origin: vertices[1])
      e_2_1 = DCEL::HalfEdge.new(origin: vertices[2])

      e_2_0 = DCEL::HalfEdge.new(origin: vertices[2])
      e_0_2 = DCEL::HalfEdge.new(origin: vertices[0])

      e_1_3 = DCEL::HalfEdge.new(origin: vertices[1])
      e_3_1 = DCEL::HalfEdge.new(origin: vertices[3])

      e_3_2 = DCEL::HalfEdge.new(origin: vertices[3])
      e_2_3 = DCEL::HalfEdge.new(origin: vertices[2])

      e_0_1.link_twin(e_1_0)
      e_1_2.link_twin(e_2_1)
      e_2_0.link_twin(e_0_2)
      e_1_3.link_twin(e_3_1)
      e_3_2.link_twin(e_2_3)
    end
  end

end
