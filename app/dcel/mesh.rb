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
    DCEL::Subdivider.subdivide_face(face, new_vertex) do |new_faces, new_edges|
      # TODO: figure out why 'self' is required here
      self.faces -= [face]
      self.faces += new_faces
      self.edges += new_edges
      self.vertices += [new_vertex]

      return new_faces
    end
  end

  private
  attr_writer :faces, :edges, :vertices

end
