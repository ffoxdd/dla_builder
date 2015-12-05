require_relative "builder"

module DCEL; end

class DCEL::Face
  def initialize(edge)
    @edge = edge
  end

  def edges
    edge.enumerator(&:next_edge).to_a
  end

  private
  attr_reader :edge
end
