require_relative "builder"
require_relative "subdivider"

module DCEL; end

class DCEL::Mesh

  def initialize(options = {})
    @faces = options.fetch(:faces, [])
    @edges = @faces.flat_map(&:edges)
    @vertices = @faces.flat_map(&:vertices)
  end

  attr_reader :faces, :edges, :vertices

  def self.triangle(vertices)
    triangle_face = DCEL::Builder.triangle(vertices)
    new(faces: [triangle_face])
  end

  def subdivide(face, new_vertex)
    old_edges = face.edges
    old_vertices = face.vertices

    new_triangles = DCEL::Subdivider.subdivide_triangle(face, new_vertex)

    new_triangle_edges = new_triangles.flat_map(&:edges).uniq(&:origin_vertex)
    new_edges = new_triangle_edges.select { |edge| edge.includes_vertex?(new_vertex) }

    # TODO: figure out why 'self' is required here
    self.faces -= [face]
    self.faces += new_triangles
    self.edges += new_edges
    self.vertices += [new_vertex]
  end

  private
  attr_writer :faces, :edges, :vertices

end
