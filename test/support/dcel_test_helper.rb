require_relative "../../app/dcel/half_edge"
require_relative "../../app/dcel/face"

module MiniTest::Assertions
  def assert_half_edge_cycle(_, half_edges) # TODO: find a better place for this assertion
    assert cycle?(half_edges), "Expected half edges to form a cycle"
  end

  def assert_face_for(half_edge, vertices)
    assert face_for_vertices?(half_edge, vertices), "Expected half edges to form a face for the given vertices"
  end

  private

  def face_for_vertices?(vertices, half_edge)
    face_edges = DCEL::Face.new(half_edge).half_edges
    cycle?(face_edges) && face_edges.map(&:origin) == vertices
  end

  def cycle?(half_edges)
    DCEL.cyclical_each_pair(half_edges).all? do |previous_half_edge, next_half_edge|
      sequentially_linked?(previous_half_edge, next_half_edge)
    end
  end

  def sequentially_linked?(previous_half_edge, next_half_edge)
    previous_half_edge.next_half_edge == next_half_edge &&
    next_half_edge.previous_half_edge == previous_half_edge
  end
end

Array.infect_an_assertion :assert_half_edge_cycle, :must_form_a_half_edge_cycle
DCEL::HalfEdge.infect_an_assertion :assert_face_for, :must_be_face_for
