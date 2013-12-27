require_relative "particle"
require_relative "grower"
require_relative "persister"
require_relative "quadtree_particle_collection"

class Dla

  def initialize(options = {}, &visitor)
    @radius = Float(options.fetch(:radius) { 4 })
    @overlap = Float(options.fetch(:overlap) { @radius / 1000.0 })

    @seeds = Array(options.fetch(:seeds) { default_seeds })
    @particles = options.fetch(:particles) { QuadtreeParticleCollection.new(@radius) }
    @visitor = visitor
    @live = options.fetch(:live) { true }

    @grower_source = options.fetch(:grower_source) { Grower }
    @persister_source = options.fetch(:persister_source) { Persister }

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
    persister(name).save
  end

  def within?(bounding_box)
    bounding_box.covers?(extent)
  end

  private

    attr_reader :grower_source, :persister_source, :seeds, :particles, :overlap, :radius, :visitor, :live
    attr_accessor :extent

    def grower
      grower_source.new(particles, radius, overlap, extent)
    end

    def persister(name)
      persister_source.new(self, name)
    end

    def add_particle(new_particle, stuck_particle = nil)
      particles << new_particle
      stuck_particle.add_child(new_particle) if stuck_particle
      accept(new_particle) if live
      check_bounds(new_particle)
    end

    def default_seeds
      [Particle.new(0, 0, radius)]
    end

    def check_bounds(particle)
      self.extent = extent.max(particle.extent)
    end

end
