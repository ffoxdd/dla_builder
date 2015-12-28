require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/local_delaunay_checker"
require_relative "../../../app/point"
require_relative "../../../app/dcel/manipulation/cycle_graph_builder"
require_relative "../../../app/dcel/manipulation/face_builder"

describe Triangulation::LocalDelaunayChecker do

  describe ".flip" do
    def split_diamond(opposite_vertex_offset: 0)
      quadrilateral_points = [
        Point[0, -1],
        Point[1 + opposite_vertex_offset, 0],
        Point[0, 1],
        Point[-1, 0]
      ]

      scaffold_face = DCEL::Manipulation::CycleGraphBuilder.cycle_graph(quadrilateral_points)
      inner_edges = scaffold_face.edge_enumerator.to_a
      e0, e1, e2, e3 = inner_edges

      right_center_edge = DCEL::Edge.new(origin_vertex: e2.origin_vertex)
      left_center_edge = DCEL::Edge.new(origin_vertex: e0.origin_vertex)

      DCEL::Edge.link_opposites(right_center_edge, left_center_edge)
      DCEL::Manipulation::FaceBuilder.face([e0, e1, right_center_edge])
      DCEL::Manipulation::FaceBuilder.face([left_center_edge, e2, e3])

      test_edge = left_center_edge
      opposite_vertex = e1.origin_vertex

      [test_edge, opposite_vertex]
    end

    it "returns true when the edge is locally delaunay" do
      edge, opposite_vertex = split_diamond(opposite_vertex_offset: 0.1)
      Triangulation::LocalDelaunayChecker.locally_delaunay?(edge).must_equal(true)
    end

    it "flips when the edge is locally delaunay" do
      edge, opposite_vertex = split_diamond(opposite_vertex_offset: -0.1)
      Triangulation::LocalDelaunayChecker.locally_delaunay?(edge).must_equal(false)
    end

    it "returns true for a constrained edge" do
      edge, opposite_vertex = split_diamond(opposite_vertex_offset: -0.1)
      edge.set_property(:constrained, true)
      Triangulation::LocalDelaunayChecker.locally_delaunay?(edge).must_equal(true)
    end
  end

end
