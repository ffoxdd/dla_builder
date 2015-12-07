require_relative "edge"
require_relative "face"
require_relative "builder"

module DCEL; end

class DCEL::Subdivider
  def self.subdivide_triangle(face, new_vertex, &block)
    new(face, new_vertex).subdivide_triangle(&block)
  end

  def initialize(face, new_vertex)
    @new_vertex = new_vertex
    @original_face_edges = face.edges
  end

  def subdivide_triangle(&block)
    new_triangles.tap do
      link_spokes
      yield(new_triangles, new_edges) if block_given?
    end
  end

  def new_triangles
    @new_triangles ||= original_face_edges.map { |edge| build_inner_triangle(edge) }
  end

  def new_edges
    @new_edges ||= edges_with_origin(new_triangles, new_vertex)
  end

  private
  attr_reader :new_vertex, :original_face_edges

  def link_spokes
    each_spoke do |inward_edge, outward_edge|
      DCEL::Builder.link_opposite(inward_edge, outward_edge)
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

  def build_inner_triangle(perimeter_edge)
    inward_edge = DCEL::Edge.new(origin_vertex: perimeter_edge.destination_vertex)
    outward_edge = DCEL::Edge.new(origin_vertex: new_vertex)
    DCEL::Builder.cyclically_link([perimeter_edge, inward_edge, outward_edge])
    DCEL::Face.new(perimeter_edge)
  end
end
