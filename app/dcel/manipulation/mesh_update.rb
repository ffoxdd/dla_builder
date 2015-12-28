require_relative "manipulation"

class DCEL::Manipulation::MeshUpdate

  def initialize(
    added_vertices: [], removed_vertices: [],
    added_edges: [], removed_edges: [],
    added_faces: [], removed_faces: [] )

    @added_vertices, @removed_vertices = added_vertices, removed_vertices
    @added_edges, @removed_edges = added_edges, removed_edges
    @added_faces, @removed_faces = added_faces, removed_faces
  end

  attr_reader :added_vertices, :removed_vertices
  attr_reader :added_edges, :removed_edges
  attr_reader :added_faces, :removed_faces

end
