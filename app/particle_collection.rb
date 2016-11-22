require_relative "quadtree"
require_relative "axis_aligned_bounding_box"
require_relative "convex_hull"
require_relative "bounding_box_finder"

require 'forwardable'

class ParticleCollection

  include Enumerable
  extend Forwardable

  def initialize(particle_radius)
    bounding_box = AxisAlignedBoundingBox.new(-2000..2000, -2000..2000)
    @particle_radius = particle_radius
    @particles = []

    @quadtree = Quadtree.new(bounding_box)
    @extent = Vector2D[0, 0]
    @convex_hull = ConvexHull.new
  end

  def closest_particle(test_particle)
    quadtree.closest_point(test_particle)
  end

  def <<(particle)
    add(particle)
  end

  def add(particle, stuck_to: nil)
    stuck_to.add_child(particle) if stuck_to
    particles << particle
    update_caches(particle)
  end

  def fits_within?(box)
    bounding_box.fits_within?(box)
  end

  def within?(box)
    axis_aligned_bounding_box.fits_within?(box)
  end

  def_delegators :particles, :size, :each, :[]
  def_delegators :convex_hull, :bounding_box, :axis_aligned_bounding_box

  private

  attr_reader  :particle_radius, :particles, :quadtree, :convex_hull
  attr_accessor :extent

  def update_caches(particle)
    quadtree << particle
    convex_hull.add_point(particle)
    self.extent = extent.max(particle.extent)
  end

end
