class Particle

  attr_reader :x, :y, :radius

  def initialize(x, y, radius)
    @x, @y, @radius = x, y, radius
  end

  def magnitude
    Math.hypot(x, y)
  end

  def extent
    magnitude + radius
  end

  def distance(particle)
    center_distance(particle) - (radius + particle.radius)
  end

  private

  def center_distance(particle)
    Math.hypot(x - particle.x, y - particle.y)
  end

end
