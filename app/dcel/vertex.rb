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
  attr_accessor :edge, :invisible

  def invisible!
    self.invisible = true
    all_adjacent_edges_enumerator.each { |edge| edge.invisible = true }
    adjacent_face_enumerator.each { |face| face.invisible = true }
  end

  private

  def all_adjacent_edges_enumerator
    adjacent_edge_enumerator.lazy.flat_map { |edge| [edge, edge.opposite_edge] }
  end



end
