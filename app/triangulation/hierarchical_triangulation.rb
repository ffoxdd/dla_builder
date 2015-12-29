require_relative "triangulation"
require_relative "hierarchical_triangle"
require_relative "../dcel/mesh"
require_relative "../dcel/manipulation/cycle_graph_builder"
require_relative "../point"
require "forwardable"

class Triangulation::HierarchicalTriangulation

  extend Forwardable

  def initialize(points: [], boundary_radius: nil)
    @mesh, @boundary_face = Boundary.context(boundary_radius)
    points.each { |point| add_point(point) }
  end

  delegate [:edge_enumerator, :vertex_enumerator, :vertex_value_enumerator] => :mesh
  alias_method :point_enumerator, :vertex_value_enumerator

  def add_point(point)
    boundary_face.add_point(point)
  end

  def hide_boundary
    boundary_face.hide
  end

  attr_reader :mesh, :boundary_face

  private

  class Boundary
    def self.context(radius)
      new(radius).context
    end

    def initialize(radius)
      @radius = radius || MAX_VALUE
    end

    def context
      DCEL::Mesh.cycle_graph(boundary_points) do |mesh, inner_face|
        return [mesh, hierarchical_face(mesh, inner_face)]
      end
    end

    private
    attr_reader :radius

    MAX_VALUE = 1e10 # representing "infinity" in a way that is guaranteed to work (for now)

    def boundary_points
      [
        Point[radius, radius], Point[-radius, radius],
        Point[-radius, -radius], Point[radius, -radius]
      ]
    end

    def hierarchical_face(mesh, graph_face)
      Triangulation::HierarchicalTriangle.new(
        mesh: mesh, graph_face: graph_face, constrained: true
      )
    end
  end

end
