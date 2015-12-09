require_relative "face"
require_relative "../ray"

module Triangulation; end

class Triangulation::HierarchicalTriangle
  def initialize(mesh:, mesh_face:)
    @mesh = mesh
    @mesh_face = mesh_face
    @triangulation_face = Triangulation::Face.new(@mesh_face.edges)
    @children = []
  end

  def points
    return triangulation_face.points if leaf?
    children.flat_map(&:points).uniq
  end

  def add_point(point)
    enclosing_triangle(point).subdivide(point)
  end

  protected

  def subdivide(point)
    new_faces = mesh.subdivide(mesh_face, point)
    self.children = new_faces.map { |face| new_triangle(face) }
    self.mesh_face = nil
  end

  def enclosing_triangle(point)
    return unless triangulation_face.contains?(point)
    return self if leaf?

    children.lazy
      .map { |child| child.enclosing_triangle(point) }
      .find { |result| !result.nil? }
  end

  private
  attr_reader :mesh, :triangulation_face
  attr_accessor :children, :mesh_face

  def new_triangle(new_mesh_face)
    Triangulation::HierarchicalTriangle.new(mesh: mesh, mesh_face: new_mesh_face)
  end

  def leaf?
    children.empty?
  end

end
