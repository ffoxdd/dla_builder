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

  def step(distance)
    translate(*random_coordinates(distance))
    self
  end

  protected

  attr_writer :x, :y # TODO: figure out why this can't be private

  private

  def translate(x_, y_)
    self.x += x_
    self.y += y_
  end

  def center_distance(particle)
    Math.hypot(x - particle.x, y - particle.y)
  end

  TWO_PI = Math::PI * 2

  def random_theta
    TWO_PI * rand
  end

  def random_coordinates(radius)
    theta = random_theta
    [Math.sin(theta) * radius, Math.cos(theta) * radius]
  end

end
