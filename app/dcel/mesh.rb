require_relative "polygon_builder"
require_relative "face_subdivider"
require_relative "vertex_deleter"

module DCEL; end

class DCEL::Mesh

  def initialize(options = {})
    @faces = options.fetch(:faces, [])
    @edges = options.fetch(:edges) { unique_edges(faces) }
    @vertices = options.fetch(:vertices) { @edges.map(&:origin_vertex) }
  end

  attr_reader :faces, :edges, :vertices

  def self.polygon(input_vertices)
    DCEL::PolygonBuilder.polygon(input_vertices) do |faces, edges, vertices|
      return new(faces: faces, edges: edges, vertices: vertices)
    end
  end

  def subdivide(face, new_vertex)
    DCEL::FaceSubdivider.subdivide_face(face, new_vertex) do |new_faces, new_edges|
      # TODO: figure out why 'self' is required here
      self.faces -= [face]
      self.faces += new_faces
      self.edges += new_edges
      self.vertices += [new_vertex]

      return new_faces
    end
  end

  def delete_vertex(edge)
    DCEL::VertexDeleter.delete_vertex(edge) do |deleted_faces, deleted_edges, deleted_vertex, added_face|
      self.faces -= deleted_faces
      self.faces += [added_face]
      self.edges -= deleted_edges
      self.vertices -= [deleted_vertex]
    end
  end

  private
  attr_writer :faces, :edges, :vertices

  def unique_edges(input_faces)
    input_faces.flat_map(&:edges).uniq(&:origin_vertex)
  end

end
