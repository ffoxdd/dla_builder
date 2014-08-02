require_relative 'point'
require_relative 'vector2d'

class Edge

  def self.[](*vertices)
    new(vertices)
  end

  def initialize(vertices)
    @vertices = vertices.map { |v| Point.new(v) }
  end

  def relative_position(point)
    v_a = displacement_vector
    v_b = v0.displacement(point)

    v_a.determinant(v_b) <=> 0
  end

  def point_to_the_left?(point)
    relative_position(point) > 0
  end

  def angle
    displacement_vector.angle
  end

  private

    attr_reader :vertices

    def v0
      vertices[0]
    end

    def v1
      vertices[1]
    end

    def displacement_vector
      v0.displacement(v1)
    end

end
