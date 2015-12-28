require_relative "manipulation"
require_relative "mesh_update"
require_relative "face_builder"
require_relative "../vertex"
require_relative "../edge"

class DCEL::Manipulation::CycleGraphBuilder
  def self.cycle_graph(vertex_values, &block)
    new(vertex_values).cycle_graph(&block)
  end

  def initialize(vertex_values)
    @vertex_values = vertex_values
  end

  def cycle_graph(&block)
    faces = [inner_face, outer_face]
    edges = inner_edges

    mesh_update = DCEL::Manipulation::MeshUpdate.new(
      added_faces: faces, added_edges: edges, added_vertices: vertices
    )

    yield(mesh_update, inner_face) if block_given?

    inner_face
  end

  private
  attr_reader :vertex_values

  def vertices
    @vertices ||= vertex_values.map { |value| DCEL::Vertex.new(value) }
  end

  def inner_face
    @inner_face ||= DCEL::Manipulation::FaceBuilder.face(inner_edges)
  end

  def outer_face
    @outer_face ||= DCEL::Manipulation::FaceBuilder.face(outer_edges)
  end

  def inner_edges
    @inner_edges ||= vertices.map { |vertex| new_edge_from_vertex(vertex) }
  end

  def outer_edges
    @outer_edges ||= inner_edges.map { |edge| new_edge_from_opposite_edge(edge) }.reverse
  end

  def new_edge_from_vertex(vertex)
    DCEL::Edge.new(origin_vertex: vertex).tap { |edge| vertex.edge = edge }
  end

  def new_edge_from_opposite_edge(edge)
    DCEL::Edge.new(origin_vertex: edge.destination_vertex).tap do |opposite_edge|
      DCEL::Edge.link_opposites(edge, opposite_edge)
    end
  end
end
