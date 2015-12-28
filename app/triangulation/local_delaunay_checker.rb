require_relative "triangulation"
require_relative "face"

class Triangulation::LocalDelaunayChecker

  def self.locally_delaunay?(edge)
    new(edge).locally_delaunay?
  end

  def initialize(edge)
    @edge = edge
  end

  def locally_delaunay?
    return true if constrained?
    !left_face.circumcircle_contains?(opposite_vertex)
  end

  private
  attr_reader :edge

  def left_face
    Triangulation::Face.new(edge.left_face)
  end

  def opposite_vertex
    edge.opposite_edge.next_edge.destination_vertex
  end

  def constrained?
    edge.has_property?(:constrained, true)
  end

end
