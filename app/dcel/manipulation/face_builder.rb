require_relative "manipulation"
require_relative "../face"
require_relative "../edge"

class DCEL::Manipulation::FaceBuilder

  def self.face(edges)
    new(edges).face
  end

  def initialize(edges)
    @edges = edges
  end

  def face
    DCEL::Face.new(edges.first).tap do |face|
      DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
        DCEL::Edge.link(previous_edge, next_edge)
        previous_edge.left_face = face
      end
    end
  end

  private
  attr_reader :edges

end
