require_relative "../ray"
require_relative "../dcel/edge" # only for the cyclical_each_pair_helper...

module Triangulation; end

class Triangulation::Face
  def initialize(points)
    @points = points
  end

  attr_reader :points

  def contains?(point)
    lines.all? { |line| line.relative_position(point) >= 0 } # includes boundary
  end

  def bounded?
    line_0, line_1 = line_enumerator.first(2)
    line_0.right_handed_orientation?(line_1)
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
end
