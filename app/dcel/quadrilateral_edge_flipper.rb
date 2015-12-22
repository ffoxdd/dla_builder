require_relative "./edge"
require_relative "./face"

module DCEL; end

class DCEL::QuadrilateralEdgeFlipper

  def self.flip(edge, &block)
    new(edge).flip(&block)
  end

  def initialize(edge)
    @edge = edge
    @perimeter_edge_0 = edge.next_edge
    @perimeter_edge_1 = @perimeter_edge_0.next_edge
    @perimeter_edge_2 = edge.opposite_edge.next_edge
    @perimeter_edge_3 = @perimeter_edge_2.next_edge
  end

  def flip
    new_left_diagonal_edge = DCEL::Edge.new(origin_vertex: perimeter_edge_1.origin_vertex)
    new_right_diagonal_edge = DCEL::Edge.new(origin_vertex: perimeter_edge_3.origin_vertex)

    DCEL::Edge.link_opposites(new_left_diagonal_edge, new_right_diagonal_edge)

    DCEL::Face.from_disjoint_edges([new_left_diagonal_edge, perimeter_edge_3, perimeter_edge_0])
    DCEL::Face.from_disjoint_edges([new_right_diagonal_edge, perimeter_edge_1, perimeter_edge_2])

    removed_edges = [edge, edge.opposite_edge]
    added_edges = [new_left_diagonal_edge, new_right_diagonal_edge]

    yield(removed_edges, added_edges) if block_given?

    new_left_diagonal_edge
  end

  private
  attr_reader :edge, :perimeter_edge_0, :perimeter_edge_1, :perimeter_edge_2, :perimeter_edge_3

end
