require_relative "triangulation"
require_relative "hierarchical_triangulation"
require_relative "delaunay_flipper"
require_relative "../../lib/enumerators/enumerator_helpers"
require "set"

class Triangulation::DelaunayTriangulation

  include EnumeratorHelpers

  def self.mesh(points)
    new(points).mesh
  end

  def initialize(points, boundary_radius: nil, boundary_hidden: true)
    @boundary_hidden = boundary_hidden

    @hierarchical_triangulation = Triangulation::HierarchicalTriangulation.new(
      points: points, boundary_radius: boundary_radius
    )

    @unprocessed_edges = hierarchical_triangulation.edge_enumerator.to_a
  end

  def mesh
    @mesh ||= hierarchical_triangulation.mesh.tap do
      flip_edges
      hide_boundary
    end
  end

  def vertex_value_enumerator
    enumerator_map(vertex_enumerator, &:value)
  end

  def vertex_enumerator
    reject_hidden(mesh.vertex_enumerator)
  end

  def edge_enumerator
    reject_hidden(mesh.edge_enumerator)
  end

  def face_enumerator
    reject_hidden(mesh.face_enumerator)
  end

  private
  attr_reader :boundary_hidden, :hierarchical_triangulation, :unprocessed_edges

  def reject_hidden(enumerator)
    enumerator_reject(enumerator) { |e| e.has_property?(:hidden, true) }
  end

  def hide_boundary
    return unless boundary_hidden
    hierarchical_triangulation.hide_boundary
  end

  def flip_edges
    while edge = unprocessed_edges.shift
      delaunay_flip(edge)
    end
  end

  def delaunay_flip(edge)
    Triangulation::DelaunayFlipper.flip(mesh: hierarchical_triangulation.mesh, edge: edge) do |affected_edges|
      unprocessed_edges.push(*affected_edges)
    end
  end

end
