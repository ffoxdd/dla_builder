require "forwardable"

module DCEL; end

class DCEL::Vertex

  extend Forwardable

  def initialize(value, edge: nil)
    @value = value
    @edge = edge
  end

  delegate [:adjacent_edge_enumerator, :adjacent_face_enumerator] => :edge

  attr_reader :value
  attr_accessor :edge

end
