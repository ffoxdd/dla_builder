module Triangulation; end

class Triangulation::Face
  def initialize(lines)
    @lines = lines.map(&:to_line)
  end

  def self.from_face(face)
    new(face.edges)
  end

  def points
    lines.map(&:point)
  end

  def contains?(point)
    lines.all? { |line| line.relative_position(point) >= 0 } # includes boundary
  end

  def bounded?
    line_0, line_1 = lines.take(2)
    line_0.right_handed_orientation?(line_1)
  end

  private
  attr_reader :lines
end
