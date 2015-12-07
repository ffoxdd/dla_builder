require_relative "builder"

module DCEL; end

class DCEL::Face
  def initialize(edge)
    @edge = edge
  end

  def self.build_from_edges(edges)
    FaceBuilder.from_edges(edges)
  end

  def opposite_face
    edge.opposite_edge.left_face
  end

  def edges
    each_edge.to_a
  end

  def vertices
    each_edge.map(&:origin_vertex)
  end

  def each_edge
    edge.each_next_edge
  end

  def eql?(face)
    vertices.eql?(face.vertices)
  end

  def hash
    vertices.hash
  end

  private
  attr_reader :edge

  module FaceBuilder
    extend self

    def from_edges(edges)
      DCEL::Face.new(edges.first).tap do |face|
        DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
          DCEL::Edge.link(previous_edge, next_edge)
          previous_edge.left_face = face
        end
      end
    end
  end

end
