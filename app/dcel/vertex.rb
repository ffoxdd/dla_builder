require_relative "dcel"
require_relative "metadata"
require "forwardable"

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

  private

  def all_adjacent_edges_enumerator
    adjacent_edge_enumerator.lazy.flat_map { |edge| [edge, edge.opposite_edge] }
  end

end
