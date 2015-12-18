require_relative "edge" # only used in FaceBuilder

module DCEL; end

class DCEL::Face
  def initialize(edge)
    @edge = edge
  end

  def self.from_disjoint_edges(edges)
    FaceBuilder.from_disjoint_edges(edges)
  end

  def self.from_connected_edge(edge)
    FaceBuilder.from_connected_edge(edge)
  end

  def self.from_vertices(edge)
    FaceBuilder.from_vertices(edge)
  end

  def opposite_face
    edge.opposite_edge.left_face
  end

  def edge_enumerator
    edge.next_edge_enumerator
  end

  def vertex_enumerator
    map_enumerator(edge_enumerator, &:origin_vertex)
  end

  def vertex_value_enumerator
    map_enumerator(vertex_enumerator, &:value)
  end

  private
  attr_reader :edge

  def map_enumerator(enumerator, &transformation) # TODO: move this somewhere more general
    Enumerator.new do |y|
      loop { y.yield(transformation.call(enumerator.next)) }
    end
  end

  module FaceBuilder
    extend self

    def from_vertices(vertices)
      edges = vertices.map { |vertex| DCEL::Edge.new(origin_vertex: vertex) }
      from_disjoint_edges(edges)
    end

    def from_disjoint_edges(edges)
      DCEL::Face.new(edges.first).tap do |face|
        DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
          DCEL::Edge.link(previous_edge, next_edge)
          previous_edge.left_face = face
        end
      end
    end

    def from_connected_edge(edge)
      DCEL::Face.new(edge).tap do |face|
        face.edge_enumerator.each { |face_edge| face_edge.left_face = face }
      end
    end
  end

end
