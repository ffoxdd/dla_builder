require_relative "point"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :radius, :children

  def initialize(x = 0, y = 0, radius = 1)
    @center = Point.new(x, y)
    @radius = Float(radius)
    @children = []
  end

  def_delegators :center, :x, :y, :magnitude

  def extent
    center.extent + Point.new(radius, radius)
  end

  def distance(particle)
    center.distance(particle) - (radius + particle.radius)
  end

  def step(distance)
    self.center += Point.random(distance)
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

  protected

    attr_accessor :center # TODO: figure out why this can't be private

    def leaf?
      children.empty?
    end

end
