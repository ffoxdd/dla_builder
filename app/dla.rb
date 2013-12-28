require_relative "particle"
require_relative "grower"
require_relative "persister"
require_relative "quadtree_particle_collection"

class Dla

  def initialize(options = {}, &visitor)
    @radius = Float(options.fetch(:radius) { 4 })
    @overlap = Float(options.fetch(:overlap) { @radius / 1000.0 })
    @seeds = Array(options.fetch(:seeds) { [Particle.new(0, 0, radius)] })
    @particles = options.fetch(:particles) { QuadtreeParticleCollection.new(@radius) }
    @live = options.fetch(:live) { true }

    @visitor = visitor
    @extent = Point.new(0, 0)

    @seeds.each { |seed| add_particle(seed) }
  end

  def grow
    grower.grow do |new_particle, stuck_particle|
      add_particle(new_particle, stuck_particle)
    end
  end

  def accept(particle = particles)
    return unless visitor
    Array(particle).each { |particle| visitor.call(particle) }
  end

  def size
    particles.size
  end

  def save(name)
    Persister.new(self, name).save
  end

  def within?(bounding_box)
    bounding_box.covers?(extent)
  end

  private

    attr_reader :seeds, :particles, :overlap, :radius, :visitor, :live
    attr_accessor :extent

    def grower
      Grower.new(particles, radius, overlap, extent)
    end

    def add_particle(new_particle, stuck_particle = nil)
      particles << new_particle
      stuck_particle.add_child(new_particle) if stuck_particle
      accept(new_particle) if live
      check_bounds(new_particle)
    end

    def check_bounds(particle)
      self.extent = extent.max(particle.extent)
    end

end