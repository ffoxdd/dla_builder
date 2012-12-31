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

end
