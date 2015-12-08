require_relative "edge"
require_relative "face"

module DCEL; end

class DCEL::PolygonBuilder
  def self.polygon(vertices, &block)
    new(vertices).polygon(&block)
  end

  def initialize(vertices)
    @vertices = vertices
  end

  def polygon(&block)
    faces = [inner_face, outer_face]
    edges = inner_edges

    yield(faces, edges, vertices) if block_given?

    inner_face
  end

  private
  attr_reader :vertices

  def inner_face
    @inner_face ||= new_face(inner_edges)
  end

  def outer_face
    @outer_face ||= new_face(outer_edges)
  end

  def inner_edges
    @inner_edges ||= vertices.map { |vertex| new_edge(vertex) }
  end

  def outer_edges
    @outer_edges ||= inner_edges.map { |edge| new_opposite_edge(edge) }.reverse
  end

  def new_opposite_edge(edge)
    new_edge(edge.destination_vertex).tap do |opposite_edge|
      DCEL::Edge.link_opposites(edge, opposite_edge)
    end
  end

  def new_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex)
  end

  def new_face(edges)
    DCEL::Face.build_from_edges(edges)
  end
end
