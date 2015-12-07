require_relative "hierarchical_triangle"
require_relative "../dcel/mesh"
require_relative "../point"

module Triangulation; end

class Triangulation::TriangleHierarchy

  def initialize
    @mesh = boundary_mesh
    @boundary_triangle = Triangulation::HierarchicalTriangle.new(mesh: mesh, face: mesh.faces.first)
  end

  def points
    boundary_triangle.points - boundary_points
  end

  def add_point(point)
    boundary_triangle.add_point(point)
  end

  private
  attr_reader :mesh, :boundary_triangle

  MAX_VALUE = 1e100 # representing "infinity" in a way that is guaranteed to work (for now)
  # TODO: consider implementing the boundary triangle with a special type

  def boundary_mesh
    DCEL::Mesh.polygon(boundary_points)
  end

  def boundary_points
    [Point[MAX_VALUE, MAX_VALUE], Point[-MAX_VALUE, MAX_VALUE], Point[0, -MAX_VALUE]]
  end

end
