require_relative "edge"
require_relative "face"
require_relative "cycle_graph_builder"

module DCEL; end

class DCEL::FaceSubdivider
  def self.subdivide_face(face, new_vertex_value, &block)
    new(face, new_vertex_value).subdivide_face(&block)
  end

  def initialize(face, new_vertex_value)
    @new_vertex_value = new_vertex_value
    @original_face_edges = face.edge_enumerator.to_a
  end

  def subdivide_face(&block)
    new_faces.tap do
      link_spokes
      yield(new_faces, new_edges, new_vertex) if block_given?
    end
  end

  def new_faces
    @new_faces ||= original_face_edges.map { |edge| build_inner_face(edge) }
  end

  def new_edges
    @new_edges ||= edges_with_origin(new_faces, new_vertex)
  end

  private
  attr_reader :new_vertex_value, :original_face_edges

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

    DCEL::Face.from_disjoint_edges([perimeter_edge, inward_edge, outward_edge])
  end

  def new_edge(origin_vertex)
    DCEL::Edge.new(origin_vertex: origin_vertex).tap do |edge|
      origin_vertex.edge = edge
    end
  end
end
