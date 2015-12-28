require_relative "../../app/triangulation/triangle_hierarchy"
require "forwardable"

module Triangulation; end

class Triangulation::HierarchicalTriangulator

  extend Forwardable

  def self.mesh(points)
    new(points).mesh
  end

  def initialize(points)
    @points = points
  end

  def mesh
    @mesh ||= triangle_hierarchy.mesh.tap { add_points }
  end

  delegate [:edge_enumerator] => :mesh
  delegate [:hide_boundary] => :triangle_hierarchy

  private
  attr_reader :points

  def add_points
    points.each { |point| triangle_hierarchy.add_point(point) }
  end

  def triangle_hierarchy
    @triangle_hierarchy ||= Triangulation::TriangleHierarchy.new
  end

end
