require_relative "quadtree"
require_relative "axis_aligned_bounding_box"
require 'forwardable'

class ParticleCollection

  include Enumerable
  extend Forwardable

  def_delegators :particles, :size, :each, :[]

  def initialize(particle_radius)
    bounding_box = AxisAlignedBoundingBox.new(-2000..2000, -2000..2000)
    @quadtree = Quadtree.new(bounding_box)
    @particles = []
    @particle_radius = particle_radius
  end

  def closest_particle(test_particle)
    quadtree.closest_point(test_particle)
  end

  def <<(particle)
    quadtree << particle
    particles << particle
  end

  private
  attr_reader :quadtree, :particles, :particle_radius

end
