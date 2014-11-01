require 'forwardable'

class Ray

  extend Forwardable

  def initialize(point, displacement_vector)
    @point = point
    @displacement_vector = displacement_vector
  end

  attr_reader :point, :displacement_vector
  alias_method :to_v, :displacement_vector

  def_delegators :displacement_vector, :angle_to, :signed_angle_to, :right_handed?

  def relative_position(test_point)
    v_a = displacement_vector
    v_b = point.displacement(test_point)

    v_a.determinant(v_b) <=> 0
  end

  def point_to_the_left?(point)
    relative_position(point) > 0
  end

  def rotate(theta)
    Ray.new(point, displacement_vector.rotate(theta))
  end

  def ==(ray)
    point == ray.point && same_direction?(displacement_vector, ray.displacement_vector)
  end

  def defining_points
    [point, point + displacement_vector]
  end

  def intersection(ray) # http://en.wikipedia.org/wiki/Line-line_intersection
    (x1, y1), (x2, y2) = defining_points.map(&:to_a)
    (x3, y3), (x4, y4) = ray.defining_points.map(&:to_a)

    denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    return if denominator == 0

    x = ((x1*y2 - y1*x2) * (x3 - x4) - (x1 - x2) * (x3*y4 - y3*x4)) / denominator
    y = ((x1*y2 - y1*x2) * (y3 - y4) - (y1 - y2) * (x3*y4 - y3*x4)) / denominator

    Point[x, y]
  end

  private

    def same_direction?(v1, v2)
      v1.determinant(v2) == 0
    end

end
