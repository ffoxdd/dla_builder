require_relative "quadtree"
require_relative "quadtree_closest_particle_finder"
require 'forwardable'

class ParticleCollection

  include Enumerable
  extend Forwardable

  def_delegators :particles, :size, :each, :[]

  def initialize(particle_radius)
    bounding_box = BoundingBox.new(-2000..2000, -2000..2000)
    @quadtree = Quadtree.new(bounding_box)
    @particles = []
    @particle_radius = particle_radius
  end

  def closest_particle(test_particle)
    closest_particle_finder(test_particle).closest_particle
  end

  def <<(particle)
    quadtree << particle
    particles << particle
  end

  private

    attr_reader :quadtree, :particles, :particle_radius

    def closest_particle_finder(test_particle)
      QuadtreeClosestParticleFinder.new(quadtree, test_particle, particle_radius)
    end

end
