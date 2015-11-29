require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/half_edge"

def test_vertex
  Object.new
end

def test_half_edge
  DCEL::HalfEdge.new(origin: test_vertex)
end

def test_triangle
  DCEL::HalfEdge.singleton(origin: test_vertex).tap do |half_edge|
    half_edge.link_vertex(test_vertex)
    half_edge.next_half_edge.link_vertex(test_vertex)
  end
end

module MiniTest::Assertions
  def assert_half_edge_cycle(_, half_edges) # TODO: find a better place for this assertion
    assert cycle?(half_edges), "Expected half edges to form a cycle"
  end

  def assert_face_for(half_edge, vertices)
    assert face_for_vertices?(half_edge, vertices), "Expected half edges to form a face for the given vertices"
  end

  private

  def face_for_vertices?(vertices, half_edge)
    face_edges = half_edge.face_edges
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

  describe "#next_vertex" do
    # TODO
  end

  describe "#face_edges" do
    # TODO
  end

  describe ".triangle" do
    it "raises ArgumentError when given less than 3 vertices" do
      proc { DCEL::HalfEdge.triangle(2.times.map { test_vertex }) }.must_raise(ArgumentError)
    end

    it "raises ArgumentError when given more than 3 vertices" do
      proc { DCEL::HalfEdge.triangle(4.times.map { test_vertex }) }.must_raise(ArgumentError)
    end

    it "creates a fully linked triangle from 3 vertices" do
      vertices = 3.times.map { test_vertex }

      half_edge_0 = DCEL::HalfEdge.triangle(vertices)
      half_edges = half_edge_0.face_edges

      half_edges.map(&:origin).must_equal(vertices)
      half_edges.must_form_a_half_edge_cycle

      twin_half_edges = half_edges.map(&:twin_half_edge)
      twin_half_edges.map(&:origin).must_equal([vertices[1], vertices[2], vertices[0]])
      twin_half_edges.reverse.must_form_a_half_edge_cycle
    end
  end

  describe "#subdivide_triangle" do
    it "subdivides a triangle about an interior vertex" do
      vertices = 3.times.map { test_vertex }
      inner_vertex = test_vertex
      half_edges = DCEL::HalfEdge.triangle(vertices).face_edges

      half_edges[0].subdivide_triangle(inner_vertex)

      half_edges[0].must_be_face_for([vertices[0], vertices[1], inner_vertex])
      half_edges[1].must_be_face_for([vertices[1], vertices[2], inner_vertex])
      half_edges[2].must_be_face_for([vertices[2], vertices[0], inner_vertex])

      half_edges[0].twin_half_edge.must_be_face_for([vertices[1], vertices[0], vertices[2]])
    end
  end

end
