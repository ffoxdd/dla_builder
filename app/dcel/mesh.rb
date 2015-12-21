require_relative "cycle_graph_builder"
require_relative "face_subdivider"
require_relative "vertex_deleter"

module DCEL; end

class DCEL::Mesh

  def initialize(options = {})
    @faces = options.fetch(:faces, [])
    @edges = options.fetch(:edges) { unique_edges(faces) }
    @vertices = options.fetch(:vertices) { @edges.map(&:origin_vertex) }
  end

  def self.cycle_graph(vertex_values)
    DCEL::CycleGraphBuilder.cycle_graph(vertex_values) do |(forward_face, reverse_face), edges, vertices|
      mesh = new(faces: [forward_face, reverse_face], edges: edges, vertices: vertices)
      yield(mesh, forward_face) if block_given?
      return mesh
    end
  end

  attr_reader :faces, :edges, :vertices

  def vertex_values
    vertices.map(&:value)
  end

  def subdivide(face, new_vertex_value)
    DCEL::FaceSubdivider.subdivide_face(face, new_vertex_value) do |new_faces, new_edges, new_vertex|
      self.faces -= [face] # not sure why 'self' is required here
      self.faces += new_faces
      self.edges += new_edges
      self.vertices += [new_vertex]

      return new_faces
    end
  end

  def delete_vertex(vertex)
    DCEL::VertexDeleter.delete_vertex(vertex) do |deleted_faces, deleted_edges, deleted_vertex, added_face|
      self.faces -= deleted_faces
      self.faces += [added_face]
      self.edges -= deleted_edges
      self.vertices -= [deleted_vertex]
    end
  end

  private
  attr_writer :faces, :edges, :vertices

  def unique_edges(input_faces)
    all_edges(input_faces).uniq(&:origin_vertex)
  end

  def all_edges(input_faces)
    input_faces.flat_map { |face| face.edge_enumerator.to_a }
  end

end
