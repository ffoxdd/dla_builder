require_relative "manipulation"
require_relative "face_builder"
require_relative "mesh_update"
require_relative "../vertex"
require_relative "../edge"

class DCEL::Manipulation::FaceSubdivider
  def self.subdivide_face(face, new_vertex_value, &block)
    new(face, new_vertex_value).subdivide_face(&block)
  end

  def initialize(face, new_vertex_value)
    @face = face
    @new_vertex_value = new_vertex_value
    @original_face_edges = face.edge_enumerator.to_a
  end

  def subdivide_face(&block)
    new_faces.tap do
      link_spokes
      yield(mesh_update) if block_given?
    end
  end

  private
  attr_reader :face, :new_vertex_value, :original_face_edges

  def mesh_update
    DCEL::Manipulation::MeshUpdate.new(
      added_faces: new_faces, removed_faces: [face],
      added_edges: new_edges, added_vertices: [new_vertex]
    )
  end

  def new_faces
    @new_faces ||= original_face_edges.map { |edge| build_inner_face(edge) }
  end

  def new_edges
    @new_edges ||= edges_with_origin(new_faces, new_vertex)
  end

  def new_vertex
    @new_vertex ||= DCEL::Vertex.new(new_vertex_value)
  end

  def link_spokes
    each_spoke do |inward_edge, outward_edge|
      DCEL::Edge.link_opposites(inward_edge, outward_edge)
    end
  end

  def edges_with_origin(faces, origin_vertex)
    all_edges = faces.flat_map { |face| face.edge_enumerator.to_a }
    all_edges.select { |edge| edge.origin_vertex.value == origin_vertex.value }
  end

  def each_spoke
    DCEL.cyclical_each_pair(original_face_edges) do |previous_edge, next_edge|
      inward_edge = previous_edge.next_edge
      outward_edge = next_edge.previous_edge

      yield(inward_edge, outward_edge)
    end
  end

  def build_inner_face(perimeter_edge)
    inward_edge = new_edge(perimeter_edge.destination_vertex)
    outward_edge = new_edge(new_vertex)

    DCEL::Manipulation::FaceBuilder.face([perimeter_edge, inward_edge, outward_edge])
  end

  def new_edge(origin_vertex)
    DCEL::Edge.new(origin_vertex: origin_vertex).tap do |edge|
      origin_vertex.edge = edge
    end
  end
end
