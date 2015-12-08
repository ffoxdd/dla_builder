require_relative "../ray"

module Triangulation; end

class Triangulation::Face
  def initialize(face)
    @face = face
  end

  def contains?(point)
    face.each_edge_enumerator.all? { |edge| ray(edge).point_to_the_left?(point) }
  end

  private
  attr_reader :face

  def ray(edge)
    Ray.from_endpoints(edge.origin_vertex, edge.destination_vertex)
  end
end
