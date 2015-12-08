require_relative "../ray"

module Triangulation; end

class Triangulation::Face
  def initialize(face)
    @face = face
  end

  def contains?(point)
    each_line_enumerator.all? { |line| line.point_to_the_left?(point) }
  end

  def bounded?
    line_0, line_1 = each_line_enumerator.take(2)
    line_0.right_handed_orientation?(line_1)
  end

  private
  attr_reader :face

  def each_line_enumerator
    Enumerator.new do |y|
      face.each_edge_enumerator.each { |edge| y.yield(ray(edge)) }
    end
  end

  def ray(edge)
    Ray.from_endpoints(edge.origin_vertex, edge.destination_vertex)
  end
end
