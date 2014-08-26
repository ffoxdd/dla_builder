require_relative 'point'
require_relative 'vector2d'
require_relative 'ray'
require 'forwardable'

class Edge

  extend Forwardable

  def initialize(initial_point, terminal_point)
    @initial_point = Point.new(initial_point)
    @terminal_point = Point.new(terminal_point)
  end

  def_delegators :ray, :relative_position, :point_to_the_left?, :angle_between, :to_v

  private

    attr_reader :initial_point, :terminal_point

    def displacement_vector
      @displacement_vector ||= initial_point.displacement(terminal_point)
    end

    def ray
      @ray ||= Ray.new(initial_point, displacement_vector)
    end

end
