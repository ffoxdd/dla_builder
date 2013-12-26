class Point

  attr_reader :x, :y

  def initialize(x, y)
    @x = Float(x)
    @y = Float(y)
  end

  def self.random(radius)
    new(*random_coordinates(radius))
  end

  def +(point)
    Point.new(x + point.x, y + point.y)
  end

  def ==(point)
    (x == point.x) && (y == point.y)
  end

  def magnitude
    Math.hypot(x, y)
  end

  def distance(point)
    Math.hypot(x - point.x, y - point.y)
  end

  def extent
    Point.new(x.abs, y.abs)
  end

  def max(point)
    Point.new([x, point.x].max, [y, point.y].max)
  end

  private

  TWO_PI = 2 * Math::PI

  def self.random_theta
    TWO_PI * rand
  end

  def self.random_coordinates(radius)
    theta = random_theta
    [Math.sin(theta) * radius, Math.cos(theta) * radius]
  end

end
