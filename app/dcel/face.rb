require_relative "builder"

module DCEL; end

class DCEL::Face
  def initialize(half_edge)
    @half_edge = half_edge
  end

  def half_edges
    half_edge.enumerator(&:next_half_edge).to_a
  end

  private
  attr_reader :half_edge
end
