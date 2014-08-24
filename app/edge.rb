require_relative 'point'
require_relative 'vector2d'

class Edge

  def self.[](initial_point, terminal_point)
    new(initial_point, terminal_point)
  end

  def initialize(initial_point, terminal_point)
    @initial_point = Point.new(initial_point)
    @terminal_point = Point.new(terminal_point)
  end

  def relative_position(point)
    v_a = displacement_vector
    v_b = initial_point.displacement(point)

    v_a.determinant(v_b) <=> 0
  end

  def point_to_the_left?(point)
    relative_position(point) > 0
  end

  def angle
    displacement_vector.angle
  end

  private

    attr_reader :initial_point, :terminal_point

    def displacement_vector
      @displacement_vector ||= initial_point.displacement(terminal_point)
    end

end
