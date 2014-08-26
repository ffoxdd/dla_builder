require 'forwardable'

class Ray

  extend Forwardable

  def initialize(point, displacement_vector)
    @point = point
    @displacement_vector = displacement_vector
  end

  def_delegators :displacement_vector, :angle_between

  def relative_position(test_point)
    v_a = displacement_vector
    v_b = point.displacement(test_point)

    v_a.determinant(v_b) <=> 0
  end

  def point_to_the_left?(point)
    relative_position(point) > 0
  end

  def to_v
    displacement_vector
  end

  private

    attr_reader :point, :displacement_vector

end
