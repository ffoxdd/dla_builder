require_relative "point"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :radius, :children

  def initialize(options = {})
    @center = options.fetch(:center) do
      Point.new(options.fetch(:x, 0), options.fetch(:y, 0))
    end

    @radius = options.fetch(:radius) { 1 }
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
    self.center += Point.random(distance)
    self
  end

  def rotate(theta)
    self.center = center.rotate(theta)
    self
  end

  protected

    attr_accessor :center # TODO: figure out why this can't be private

    def leaf?
      children.empty?
    end

end
