require_relative "../../app/triangulation/triangle_hierarchy"

module Triangulation; end

class Triangulation::HierarchicalTriangulator

  def self.mesh(points)
    new(points).mesh
  end

  def initialize(points)
    @points = points
    @triangle_hierarchy = Triangulation::TriangleHierarchy.new
    @hierarchy_mesh = @triangle_hierarchy.mesh
    @boundary_vertices = @hierarchy_mesh.vertices
  end

  def mesh
    @mesh ||= hierarchy_mesh.tap do
      add_points
      make_boundary_invisible
    end
  end

  private
  attr_reader :points, :triangle_hierarchy, :hierarchy_mesh, :boundary_vertices

  def add_points
    points.each { |point| triangle_hierarchy.add_point(point) }
  end

  def make_boundary_invisible
    boundary_vertices.each { |vertex| vertex.invisible! }
  end
end
