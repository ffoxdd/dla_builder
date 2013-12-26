require_relative "particle"
require_relative "grower"
require_relative "persister"
require_relative "quadtree_particle_collection"

class Dla

  def initialize(options = {}, &visitor)
    @radius = Float(options.fetch(:radius) { 4 })
    @overlap = Float(options.fetch(:overlap) { @radius / 8.0 })

    @seeds = Array(options.fetch(:seeds) { default_seeds })
    @particles = options.fetch(:particles) { QuadtreeParticleCollection.new(@radius) }
    @visitor = visitor
    @live = options.fetch(:live) { true }

    @grower_source = options.fetch(:grower_source) { Grower }
    @persister = options.fetch(:persister) { Persister }

    @extent = Point.new(0, 0)

    @seeds.each { |seed| @particles << seed }
    check_bounds(particles)
    accept if @live
  end

  def grow
    new_particle = grower.grow # CQS violation
    check_bounds(new_particle)
    add_particle(new_particle)
  end

  def accept(particle = particles)
    return unless visitor
    Array(particle).each { |particle| visitor.call(particle) }
  end

  def size
    particles.size
  end

  def save(name)
    persister.save(self, name)
  end

  def within?(bounding_box)
    bounding_box.covers?(extent)
  end

  private

  attr_reader :grower_source, :persister, :seeds, :particles, :overlap, :radius, :visitor, :live
  attr_accessor :extent

  def grower
    grower_source.new(particles, radius, overlap, extent)
  end

  def add_particle(particle)
    particles << particle
    accept(particle) if live
  end

  def default_seeds
    [Particle.new(0, 0, radius)]
  end

  def check_bounds(particles)
    Array(particles).each { |particle| self.extent = extent.max(particle.extent) }
  end

end
