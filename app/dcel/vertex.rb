require_relative "metadata"
require "forwardable"

module DCEL; end

class DCEL::Vertex

  include DCEL::Metadata
  extend Forwardable

  def initialize(value, edge: nil)
    @value = value
    @edge = edge
  end

  delegate [:adjacent_edge_enumerator, :adjacent_face_enumerator] => :edge

  attr_reader :value
  attr_accessor :edge

  def set_property(property, value, neighbors: false)
    super(property, value)
    set_property_on_neighbors(property, value) if neighbors
  end

  private

  def all_adjacent_edges_enumerator
    adjacent_edge_enumerator.lazy.flat_map { |edge| [edge, edge.opposite_edge] }
  end

  def set_property_on_neighbors(property, value)
    all_adjacent_edges_enumerator.each { |edge| edge.set_property(property, value) }
    adjacent_face_enumerator.each { |face| face.set_property(property, value) }
  end

end
