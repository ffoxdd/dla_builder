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
    points.each { |point| triangle_hierarchy.add_point(point) }
    boundary_vertices.each { |vertex| hierarchy_mesh.delete_vertex(vertex) }
    hierarchy_mesh
  end

  private
  attr_reader :points, :triangle_hierarchy, :hierarchy_mesh, :boundary_vertices
end
