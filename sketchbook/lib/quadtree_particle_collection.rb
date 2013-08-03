require 'forwardable'
require File.join(File.dirname(__FILE__), "quadtree")
require File.join(File.dirname(__FILE__), "quadtree_closest_particle_finder")

class QuadtreeParticleCollection

  include Enumerable
  extend Forwardable

  def_delegators :particles, :size, :<<, :each

  def initialize(particle_radius)
    @particles = Quadtree.new(-2000..2000, -2000..2000)
    @particle_radius = particle_radius
  end

  def closest_particle(test_particle)
    closest_particle_finder(test_particle).closest_particle
  end

  private

  attr_reader :particles, :particle_radius

  def closest_particle_finder(test_particle)
    QuadtreeClosestParticleFinder.new(particles, test_particle, particle_radius)
  end

end
