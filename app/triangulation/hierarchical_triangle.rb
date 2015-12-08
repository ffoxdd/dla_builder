require_relative "face"
require_relative "../ray"

module Triangulation; end

class Triangulation::HierarchicalTriangle
  def initialize(options = {})
    @mesh = options.fetch(:mesh)
    @face = options.fetch(:face)
    @children = []
  end

  def add_point(point)
    enclosing_triangle(point).subdivide(point)
  end

  def subdivide(point)
    new_faces = mesh.subdivide(face, point)
    self.children = new_faces.map { |face| new_triangle(face) }
    self.face = nil
  end

  def points
    return face.vertices if leaf?
    children.flat_map(&:points).uniq
  end

  private
  attr_reader :mesh
  attr_accessor :face, :children

  def new_triangle(new_face)
    Triangulation::HierarchicalTriangle.new(mesh: mesh, face: new_face)
  end

  def enclosing_triangle(point)
    return unless contains?(point)
    return self if leaf?
    children.find { |triangle| triangle.enclosing_triangle(point) }
  end

  def leaf?
    children.empty?
  end

  def contains?(point)
    Triangulation::Face.new(face).contains?(point)
  end

end
