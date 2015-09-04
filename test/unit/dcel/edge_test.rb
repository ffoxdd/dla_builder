require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/edge"

def test_vertex
  Object.new
end

describe DCEL::Edge do

  describe "next/previous/twin" do
    it "returns the next/previous edge" do
      previous_edge = DCEL::Edge.new(origin: test_vertex)
      next_edge = DCEL::Edge.new(origin: test_vertex)
      twin_edge = DCEL::Edge.new(origin: test_vertex)

      edge = DCEL::Edge.new(
        origin: test_vertex, previous: previous_edge, next: next_edge, twin: twin_edge
      )

      edge.previous.must_equal(previous_edge)
      edge.next.must_equal(next_edge)
      edge.twin.must_equal(twin_edge)
    end
  end

end
