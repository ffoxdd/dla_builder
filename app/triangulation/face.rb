require_relative "../ray"
require_relative "../dcel/edge" # only for the cyclical_each_pair_helper...

module Triangulation; end

class Triangulation::Face
  def initialize(graph_face)
    @points = graph_face.vertex_value_enumerator.to_a
  end

  attr_reader :points

  def contains?(point)
    lines.all? { |line| line.relative_position(point) >= 0 } # includes boundary
  end

  def bounded?
    line_0, line_1 = line_enumerator.first(2)
    line_0.right_handed_orientation?(line_1)
  end

  def circumcircle_contains?(vertex)
    Circumcircle.new(points).contains?(vertex.value)
  end

  private

  def lines
    line_enumerator.to_a
  end

  def line_enumerator
    DCEL.cyclical_each_pair(points).map do |previous_point, next_point|
      Ray.from_endpoints(previous_point, next_point)
    end
  end

  def lines_from_points(points)
    DCEL.cyclical_each_pair(points).map do |previous_point, next_point|
      Ray.from_endpoints(previous_point, next_point)
    end
  end

  class Circumcircle
    def initialize(points)
      @points = points
    end

    def contains?(point)
      containment_test_matrix(point).determinant >= 0
    end

    private
    attr_reader :points

    def containment_test_matrix(test_point)
      Matrix[
        point_row(points[0]),
        point_row(points[1]),
        point_row(points[2]),
        point_row(test_point)
      ]
    end

    def point_row(point)
      [point.x, point.y, point.inner_product(point), 1]
    end
  end

end
