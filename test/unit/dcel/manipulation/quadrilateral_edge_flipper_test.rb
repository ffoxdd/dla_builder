require_relative "../../../test_helper"
require_relative "../../../../app/dcel/manipulation/quadrilateral_edge_flipper"
require_relative "../../../../app/vector2d"
require_relative "../../../../app/dcel/manipulation/cycle_graph_builder"
require_relative "../../../../app/dcel/manipulation/face_builder"
require "set"

describe DCEL::Manipulation::QuadrilateralEdgeFlipper do

  describe ".flip" do
    def split_diamond
      quadrilateral_points = [Vector2D[0, -1], Vector2D[1, 0], Vector2D[0, 1], Vector2D[-1, 0]]

      scaffold_face = DCEL::Manipulation::CycleGraphBuilder.cycle_graph(quadrilateral_points)
      perimeter_edges = scaffold_face.edge_enumerator.to_a
      e0, e1, e2, e3 = perimeter_edges

      right_diagonal_edge = DCEL::Edge.new(origin_vertex: e2.origin_vertex)
      left_diagonal_edge = DCEL::Edge.new(origin_vertex: e0.origin_vertex)

      DCEL::Edge.link_opposites(right_diagonal_edge, left_diagonal_edge)
      DCEL::Manipulation::FaceBuilder.face([e0, e1, right_diagonal_edge])
      DCEL::Manipulation::FaceBuilder.face([left_diagonal_edge, e2, e3])

      opposite_vertex = e1.origin_vertex
      diagonal_edges = [right_diagonal_edge, left_diagonal_edge]

      [diagonal_edges, perimeter_edges]
    end

    it "flips the inner edges of a quadrilateral" do
      diagonal_edges, perimeter_edges = split_diamond
      edge_to_flip = diagonal_edges.first

      DCEL::Manipulation::QuadrilateralEdgeFlipper.flip(edge_to_flip) do |mesh_update, affected_edges|
        mesh_update.removed_faces.size.must_equal(2)
        mesh_update.added_faces.size.must_equal(2)
        Set.new(affected_edges).must_equal(Set.new(perimeter_edges))
      end

      faces = perimeter_edges.map(&:left_face).uniq

      bottom_face = faces.find { |f| f.edge_enumerator.include?(perimeter_edges[0]) }
      top_face = faces.find { |f| f.edge_enumerator.include?(perimeter_edges[2]) }

      bottom_face_points = bottom_face.vertex_value_enumerator.to_a
      top_face_points = top_face.vertex_value_enumerator.to_a

      bottom_face_points.must_cyclically_equal([Vector2D[0, -1], Vector2D[1, 0], Vector2D[-1, 0]])
      top_face_points.must_cyclically_equal([Vector2D[0, 1], Vector2D[-1, 0], Vector2D[1, 0]])
    end
  end

end
