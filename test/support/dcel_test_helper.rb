require_relative "../../app/dcel/edge"
require_relative "../../app/dcel/face"

def test_vertex
  Object.new
end

def test_edge
  DCEL::Edge.new(origin_vertex: test_vertex)
end

module MiniTest::Assertions
  def assert_edge_cycle(_, edges) # TODO: find a better place for this assertion
    assert cycle?(edges), "Expected edges to form a cycle"
  end

  def assert_face_for(edge, vertices)
    assert face_for_vertices?(edge, vertices), "Expected edges to form a face for the given vertices"
  end

  private

  def face_for_vertices?(vertices, edge)
    face_edges = DCEL::Face.new(edge).edges
    cycle?(face_edges) && face_edges.map(&:origin_vertex) == vertices
  end

  def cycle?(edges)
    DCEL.cyclical_each_pair(edges).all? do |previous_edge, next_edge|
      sequentially_linked?(previous_edge, next_edge)
    end
  end

  def sequentially_linked?(previous_edge, next_edge)
    previous_edge.next_edge == next_edge &&
    next_edge.previous_edge == previous_edge
  end
end

Array.infect_an_assertion :assert_edge_cycle, :must_form_a_edge_cycle
DCEL::Edge.infect_an_assertion :assert_face_for, :must_be_face_for
