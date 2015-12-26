require_relative "./hierarchical_triangulator"
require_relative "./delaunay_flipper"
require_relative "hierarchical_triangulator"
require_relative "delaunay_flipper"
require "set"

module Triangulation; end

class Triangulation::DelaunayTriangulator

  def self.mesh(points)
    new(points).mesh
  end

  def initialize(points)
    @points = points
    @unprocessed_edges = arbitrary_triangulation_mesh.edge_enumerator.to_a
  end

  def mesh
    @mesh ||= arbitrary_triangulation_mesh.tap do
      while edge = unprocessed_edges.shift do
        delaunay_flip(edge)
      end
    end
  end

  private
  attr_reader :points, :unprocessed_edges

  def delaunay_flip(edge)
    Triangulation::DelaunayFlipper.flip(mesh: mesh, edge: edge) do |affected_edges|
      unprocessed_edges.push(*affected_edges)
    end
  end

  def arbitrary_triangulation_mesh
    @arbitrary_triangulation_mesh ||= Triangulation::HierarchicalTriangulator.mesh(points)
  end

end
