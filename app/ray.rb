require 'forwardable'

class Ray

  extend Forwardable

  def initialize(point, displacement_vector)
    @point = point
    @displacement_vector = displacement_vector
  end

  attr_reader :point, :displacement_vector
  alias_method :to_v, :displacement_vector

  def_delegators :displacement_vector, :angle_between

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

  private

    def same_direction?(v1, v2)
      v1.determinant(v2) == 0
    end

end
