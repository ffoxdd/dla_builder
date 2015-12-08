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
    Polygon.new(face).contains?(point)
  end

  class Polygon
    def initialize(face)
      @face = face
    end

    def contains?(point)
      face.each_edge_enumerator.all? { |edge| ray(edge).point_to_the_left?(point) }
    end

    private
    attr_reader :face

    def ray(edge)
      Ray.from_endpoints(edge.origin_vertex, edge.destination_vertex)
    end
  end

end
