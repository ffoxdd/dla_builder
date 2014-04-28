require_relative "point"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :center, :radius, :children

  def initialize(options = {})
    @center = options.fetch(:center) do
      x = options.fetch(:x, 0)
      y = options.fetch(:y, 0)

      Point.new(x, y)
    end

    @radius = options.fetch(:radius, 1)
    @children = []
  end

  def_delegators :center, :x, :y, :magnitude

  def extent
    center.extent + Point.new(radius, radius)
  end

  def distance(particle)
    center.distance(particle) - (radius + particle.radius)
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

  protected

    attr_writer :center

    def leaf?
      children.empty?
    end

end
