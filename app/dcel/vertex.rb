module DCEL; end

class DCEL::Vertex

  extend Forwardable

  def initialize(value, edge: nil)
    @value = value
    @edge = edge
  end

  delegate [:each_adjacent_edge_enumerator, :adjacent_edges] => :edge
  delegate [:each_adjacent_face_enumerator, :adjacent_faces] => :edge

  attr_reader :value
  attr_accessor :edge

end
