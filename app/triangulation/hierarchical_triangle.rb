require_relative "face"
require_relative "../ray"

module Triangulation; end

class Triangulation::HierarchicalTriangle

  def initialize(mesh:, graph_face:, constrained: false)
    @mesh = mesh
    @graph_face = graph_face
    @face = Triangulation::Face.new(@graph_face)
    @children = []

    constrain if constrained
  end

  def points
    return face.points if leaf?
    children.flat_map(&:points).uniq
  end

  def add_point(point)
    enclosing_triangle(point).subdivide(point)
  end

  def hide
    face.set_neighbors_properties(:hidden, true)
  end

  protected

  def subdivide(point)
    new_faces = mesh.subdivide(graph_face, point)
    self.children = new_faces.map { |face| new_triangle(face) }
    self.graph_face = nil
  end

  def enclosing_triangle(point)
    return unless face.contains?(point)
    return self if leaf?

    children.lazy
      .map { |child| child.enclosing_triangle(point) }
      .find { |result| !result.nil? }
  end

  private
  attr_reader :mesh, :face
  attr_accessor :children, :graph_face

  def new_triangle(new_graph_face)
    Triangulation::HierarchicalTriangle.new(mesh: mesh, graph_face: new_graph_face)
  end

  def leaf?
    children.empty?
  end

  def constrain
    graph_face.edge_enumerator.each { |edge| edge.set_property(:constrained, true) }
  end

end
