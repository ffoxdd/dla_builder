require 'forwardable'
require File.join(File.dirname(__FILE__), "quadtree")
require File.join(File.dirname(__FILE__), "quadtree_closest_particle_finder")

class QuadtreeParticleCollection

  include Enumerable
  extend Forwardable

  def_delegators :particles, :size, :<<, :each

  def initialize(options = {})
    @particles = Quadtree.new(-2000..2000, -2000..2000)
    @radius = Float(options.fetch(:radius) { 4 })
  end

  def closest_particle(test_particle)
    QuadtreeClosestParticleFinder.new(particles, test_particle, radius).closest_particle
  end

  private

  attr_reader :particles, :radius

end
