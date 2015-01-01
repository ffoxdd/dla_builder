require_relative "particle"
require_relative "grower"
require_relative "persister"
require_relative "particle_collection"
require_relative "convex_hull"
require_relative "bounding_box_finder"

class Dla

  def initialize(options = {}, &live_visitor)
    @particle_radius = Float( options.fetch(:particle_radius, 4) ) # radius of each particle
    @overlap = Float( options.fetch(:overlap) { @particle_radius / 1000.0 } )
    @seeds = Array( options.fetch(:seeds) { [Particle.new(radius: particle_radius)] } )
    @live_visitor = live_visitor

    @particles = ParticleCollection.new(@particle_radius)
    @extent = Point[0, 0]
    @convex_hull = ConvexHull.new

    @seeds.each { |seed| add_particle(seed) }
  end

  attr_reader :particles, :convex_hull, :bounding_box

  def grow
    grower.grow do |new_particle, stuck_particle|
      add_particle(new_particle, stuck_particle)
    end
  end

  def accept(options = {}, &visitor)
    particles.each do |particle|
      accept_particle(particle.transform(options), &visitor)
    end
  end

  def size
    particles.size
  end

  def save(name)
    Persister.new(self, name).save
  end

  def within?(box)
    box.covers?(extent)
  end

  def fits_within?(box)
    bounding_box.fits_within?(box)
  end

  private

    attr_reader :seeds, :overlap, :particle_radius, :live_visitor
    attr_writer :bounding_box
    attr_accessor :extent

    def grower
      Grower.new(particles, particle_radius, overlap, extent)
    end

    def add_particle(new_particle, stuck_particle = nil)
      particles << new_particle
      stuck_particle.add_child(new_particle) if stuck_particle
      accept_particle(new_particle, &live_visitor)
      check_bounds(new_particle)
      update_bounding_box(new_particle)
    end

    def check_bounds(particle)
      self.extent = extent.max(particle.extent)
    end

    def update_bounding_box(particle)
      convex_hull.add_point(particle.center)
      self.bounding_box = BoundingBoxFinder.new(convex_hull.polygon).bounding_box
    end

    def accept_particle(particle, &visitor)
      return unless visitor
      visitor.arity == 1 ? visitor.call(particle) : visitor.call(particle, self)
    end

end
