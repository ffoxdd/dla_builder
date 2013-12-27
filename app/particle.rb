require_relative "point"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :radius, :children

  def initialize(x, y, radius)
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

  protected

    attr_accessor :center # TODO: figure out why this can't be private

end
