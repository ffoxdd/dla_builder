require_relative "point"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :center, :radius, :children

  def initialize(options = {})
    coordinates = options.fetch(:center) do
      [options.fetch(:x, 0), options.fetch(:y, 0)]
    end.to_a

    @center = Point.new(coordinates)
    @radius = options.fetch(:radius, 1)
    @children = []
  end

  def_delegators :center, :x, :y, :magnitude

  def extent
    Point.new(center.extent + Point[radius, radius])
  end

  def distance(particle)
    center.distance(particle.center) - (radius + particle.radius)
  end

  def within_radius?(test_radius)
    extent.magnitude < test_radius
  end

  def add_child(particle)
    children.push(particle)
  end

  def depth
    return 0 if leaf?
    children.map { |child| child.depth + 1 }.max
  end

  def step(distance)
    Particle.new(center: center + Point.random(distance), radius: radius)
  end

  def rotate(theta)
    Particle.new(center: center.rotate(theta), radius: radius)
  end

  def inspect
    {x: x, y: y, radius: radius}.inspect
  end

  def +(offset)
    Particle.new(center: center + offset, radius: radius)
  end

  def -(offset)
    Particle.new(center - offset, radius: radius)
  end

  def transform(options = {})
    offset = options.fetch(:offset) { Vector2D[0, 0] }
    rotation = options.fetch(:rotation) { 0 }

    rotate(rotation) + offset
  end

  protected
  attr_writer :center

  def leaf?
    children.empty?
  end

end
