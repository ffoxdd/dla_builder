require_relative "../../app/triangulation/triangle_hierarchy"

module Triangulation; end

class Triangulation::HierarchicalTriangulator

  def self.mesh(points)
    new(points).mesh
  end

  def initialize(points)
    @points = points
  end

  def mesh
    @mesh ||= triangle_hierarchy.mesh.tap { add_points }
  end

  private
  attr_reader :points

  def add_points
    points.each { |point| triangle_hierarchy.add_point(point) }
  end

  def triangle_hierarchy
    @triangle_hierarchy ||= Triangulation::TriangleHierarchy.new
  end

end
