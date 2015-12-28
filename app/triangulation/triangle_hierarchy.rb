require_relative "hierarchical_triangle"
require_relative "../dcel/mesh"
require_relative "../dcel/cycle_graph_builder"
require_relative "../point"
require "forwardable"

module Triangulation; end

class Triangulation::TriangleHierarchy

  extend Forwardable

  def initialize(points = [])
    DCEL::Mesh.cycle_graph(boundary_points) do |mesh, boundary_face|
      @mesh = mesh
      @boundary_triangle = new_hierarchichal_triangle(boundary_face, constrained: true)
    end

    points.each { |point| add_point(point) }
  end

  delegate [:edge_enumerator, :vertex_enumerator, :vertex_value_enumerator] => :mesh
  alias_method :point_enumerator, :vertex_value_enumerator

  def add_point(point)
    boundary_triangle.add_point(point)
  end

  def hide_boundary
    boundary_triangle.hide
  end

  attr_reader :mesh, :boundary_triangle

  private

  MAX_VALUE = 1e10 # representing "infinity" in a way that is guaranteed to work (for now)

  def boundary_points
    [Point[MAX_VALUE, MAX_VALUE], Point[-MAX_VALUE, MAX_VALUE], Point[0, -MAX_VALUE]]
  end

  def new_hierarchichal_triangle(graph_face, constrained: false)
    Triangulation::HierarchicalTriangle.new(mesh: mesh, graph_face: graph_face)
  end

end
