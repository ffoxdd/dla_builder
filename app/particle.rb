require_relative "point"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :radius

  def initialize(x, y, radius)
    @center = Point.new(x, y)
    @radius = Float(radius)
  end

  def_delegators :center, :x, :y, :magnitude

  def extent
    magnitude + radius
  end

  def x_extent
    x.abs + radius
  end

  def y_extent
    y.abs + radius
  end

  def distance(particle)
    center.distance(particle) - (radius + particle.radius)
  end

  def step(distance)
    self.center += Point.random(distance)
  end

  protected

  attr_accessor :center # TODO: figure out why this can't be private

end
