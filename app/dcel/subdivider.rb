require_relative "edge"
require_relative "face"
require_relative "polygon_builder"

module DCEL; end

class DCEL::Subdivider
  def self.subdivide_face(face, new_vertex, &block)
    new(face, new_vertex).subdivide_face(&block)
  end

  def initialize(face, new_vertex)
    @new_vertex = new_vertex
    @original_face_edges = face.edges
  end

  def subdivide_face(&block)
    new_faces.tap do
      link_spokes
      yield(new_faces, new_edges) if block_given?
    end
  end

  def new_faces
    @new_faces ||= original_face_edges.map { |edge| build_inner_face(edge) }
  end

  def new_edges
    @new_edges ||= edges_with_origin(new_faces, new_vertex)
  end

  private
  attr_reader :new_vertex, :original_face_edges

  def link_spokes
    each_spoke do |inward_edge, outward_edge|
      DCEL::Edge.link_opposites(inward_edge, outward_edge)
    end
  end

  def edges_with_origin(faces, origin_vertex)
    faces.flat_map(&:edges).select { |edge| edge.origin_vertex == origin_vertex }
  end

  def each_spoke
    DCEL.cyclical_each_pair(original_face_edges) do |previous_edge, next_edge|
      inward_edge = previous_edge.next_edge
      outward_edge = next_edge.previous_edge

      yield(inward_edge, outward_edge)
    end
  end

  def build_inner_face(perimeter_edge)
    inward_edge = DCEL::Edge.new(origin_vertex: perimeter_edge.destination_vertex)
    outward_edge = DCEL::Edge.new(origin_vertex: new_vertex)
    DCEL::Face.build_from_edges([perimeter_edge, inward_edge, outward_edge])
  end
end
