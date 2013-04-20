class Quadtree

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
    @particles = []
  end

  def size
    @particles.size
  end

  def add(particle)
    @particles.push(particle)
  end

  def contains?(particle)
    x_range.include?(particle.x) && y_range.include?(particle.y)
  end

  private

  attr_reader :x_range, :y_range

end
