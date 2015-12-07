require_relative "builder"
require_relative "subdivider"
require_relative "vertex_deleter"

module DCEL; end

class DCEL::Mesh

  def initialize(options = {})
    @faces = options.fetch(:faces, [])
    @edges = @faces.flat_map(&:edges)
    @vertices = @faces.flat_map(&:vertices)
  end

  attr_reader :faces, :edges, :vertices

  def self.face(vertices)
    face = DCEL::Builder.face(vertices)
    new(faces: [face])
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

  def delete_vertex(edge)
    DCEL::VertexDeleter.delete_vertex(edge) do |deleted_faces, deleted_edges, deleted_vertex|
      # self.faces -= deleted_faces
      self.edges -= deleted_edges
      self.vertices -= [deleted_vertex]
    end
  end

  private
  attr_writer :faces, :edges, :vertices

end
