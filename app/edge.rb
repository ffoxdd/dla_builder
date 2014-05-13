require_relative 'point'
require_relative 'vector2d'

class Edge

  def self.[](*vertices)
    new(vertices)
  end

  def initialize(vertices)
    @vertices = vertices.map { |v| Point.new(v) }
  end

  def displacement_vector
    Vector2D.new((v1 - v0).to_a)
  end

  def relative_position(point)
    v_a = displacement_vector
    v_b = point - v0

    v_a.determinant(v_b) <=> 0
  end

  private

    attr_reader :vertices

    def v0
      vertices[0]
    end

    def v1
      vertices[1]
    end

end
