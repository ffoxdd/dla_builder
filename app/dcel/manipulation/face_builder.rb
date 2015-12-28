require_relative "manipulation"
require_relative "../face"
require_relative "../edge"
require_relative "../../../lib/enumerators/enumerator_helpers"

class DCEL::Manipulation::FaceBuilder

  include EnumeratorHelpers

  def self.face(edges)
    new(edges).face
  end

  def initialize(edges)
    @edges = edges
  end

  def face
    DCEL::Face.new(edges.first).tap do |face|
      cyclical_pairs_enumerator(edges).each do |previous_edge, next_edge|
        DCEL::Edge.link(previous_edge, next_edge)
        previous_edge.left_face = face
      end
    end
  end

  private
  attr_reader :edges

end
