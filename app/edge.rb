require_relative 'vector2d'
require_relative 'ray'
require 'forwardable'

class Edge

  extend Forwardable

  def initialize(initial_point, terminal_point)
    @initial_point = Vector2D.new(initial_point)
    @terminal_point = Vector2D.new(terminal_point)
  end

  def_delegators :ray,
    :relative_position, :point_to_the_left?,
    :angle_to, :signed_angle_to, :to_v, :right_handed?

  def displacement_vector
    @displacement_vector ||= initial_point.displacement(terminal_point)
  end

  def ray
    @ray ||= Ray.new(initial_point, displacement_vector)
  end

  def length
    initial_point.distance(terminal_point)
  end

  private

    attr_reader :initial_point, :terminal_point

end
