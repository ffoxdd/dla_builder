require_relative "half_edge"
require_relative "face"
require_relative "builder"

module DCEL; end

class DCEL::Subdivider
  def initialize(face, inner_vertex)
    @inner_vertex = inner_vertex
    @original_face_edges = face.half_edges
  end

  def subdivide_triangle
    build_inner_triangles
    link_spokes
  end

  private
  attr_reader :inner_vertex, :original_face_edges

  def link_spokes
    each_spoke { |inward_edge, outward_edge| DCEL::Builder.link_twin(inward_edge, outward_edge) }
  end

  def build_inner_triangles
    original_face_edges.each { |half_edge| build_inner_triangle(half_edge) }
  end

  def each_spoke
    DCEL.cyclical_each_pair(original_face_edges) do |previous_half_edge, next_half_edge|
      inward_edge = previous_half_edge.next_half_edge
      outward_edge = next_half_edge.previous_half_edge

      yield(inward_edge, outward_edge)
    end
  end

  def build_inner_triangle(perimeter_half_edge)
    inward_edge = DCEL::HalfEdge.new(origin_vertex: perimeter_half_edge.destination_vertex)
    outward_edge = DCEL::HalfEdge.new(origin_vertex: inner_vertex)

    DCEL::Builder.cyclically_link([perimeter_half_edge, inward_edge, outward_edge])
  end
end
