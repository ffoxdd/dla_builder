require_relative "./face"
require "forwardable"

module Triangulation; end

class Triangulation::DelaunayFlipper

  extend Forwardable

  def self.flip(mesh:, edge:, &block)
    new(mesh: mesh, edge: edge).flip(&block)
  end

  def initialize(mesh:, edge:)
    @mesh = mesh
    @edge = edge
  end

  def flip(&block)
    flip_edge(&block) if !locally_delaunay?
  end

  private
  attr_reader :mesh, :edge

  def flip_edge(&block)
    mesh.flip_quadrilateral_edge(edge, &block)
  end

  def locally_delaunay?
    Triangulation::LocalDelaunayChecker.locally_delaunay?(edge)
  end

end
