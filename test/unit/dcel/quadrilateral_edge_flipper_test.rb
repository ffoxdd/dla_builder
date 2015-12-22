require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/quadrilateral_edge_flipper"
require_relative "../../../app/point"
require_relative "../../../app/dcel/cycle_graph_builder"
require "set"

describe DCEL::QuadrilateralEdgeFlipper do

  describe ".flip" do
    def split_diamond
      quadrilateral_points = [Point[0, -1], Point[1, 0], Point[0, 1], Point[-1, 0]]

      scaffold_face = DCEL::CycleGraphBuilder.cycle_graph(quadrilateral_points)
      perimeter_edges = scaffold_face.edge_enumerator.to_a
      e0, e1, e2, e3 = perimeter_edges

      right_diagonal_edge = DCEL::Edge.new(origin_vertex: e2.origin_vertex)
      left_diagonal_edge = DCEL::Edge.new(origin_vertex: e0.origin_vertex)

      DCEL::Edge.link_opposites(right_diagonal_edge, left_diagonal_edge)
      DCEL::Face.from_disjoint_edges([e0, e1, right_diagonal_edge])
      DCEL::Face.from_disjoint_edges([left_diagonal_edge, e2, e3])

      opposite_vertex = e1.origin_vertex
      diagonal_edges = [right_diagonal_edge, left_diagonal_edge]

      [diagonal_edges, perimeter_edges]
    end

    it "flips the inner edges of a quadrilateral" do
      diagonal_edges, perimeter_edges = split_diamond
      edge_to_flip = diagonal_edges.first

      removed_edges = nil
      added_edges = nil

      DCEL::QuadrilateralEdgeFlipper.flip(edge_to_flip) do |removed_edges_, added_edges_|
        removed_edges = removed_edges_
        added_edges = added_edges_
      end

      Set.new(removed_edges).must_equal(Set.new(diagonal_edges))

      faces = perimeter_edges.map(&:left_face).uniq

      bottom_face = faces.find { |f| f.edge_enumerator.include?(perimeter_edges[0]) }
      top_face = faces.find { |f| f.edge_enumerator.include?(perimeter_edges[2]) }

      bottom_face_points = bottom_face.vertex_value_enumerator.to_a
      top_face_points = top_face.vertex_value_enumerator.to_a

      bottom_face_points.must_cyclically_equal([Point[0, -1], Point[1, 0], Point[-1, 0]])
      top_face_points.must_cyclically_equal([Point[0, 1], Point[-1, 0], Point[1, 0]])
    end
  end

end
