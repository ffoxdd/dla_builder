require_relative "particle"
require_relative "grower"
require_relative "persister"
require_relative "particle_collection"

class Dla

  def initialize(options = {}, &live_visitor)
    @radius = Float(options.fetch(:radius) { 4 })
    @overlap = Float(options.fetch(:overlap) { @radius / 1000.0 })
    @seeds = Array(options.fetch(:seeds) { [Particle.new(radius: radius)] })
    @rotation = options.fetch(:rotation) { 0 }
    @live_visitor = live_visitor

    @particles = ParticleCollection.new(@radius)
    @extent = Point.new(0, 0)

    @seeds.each { |seed| add_particle(seed) }
  end

  attr_reader :particles

  def grow
    grower.grow do |new_particle, stuck_particle|
      add_particle(new_particle, stuck_particle)
    end
  end

  def accept(&visitor)
    particles.each { |particle| accept_particle(particle, &visitor) }
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

    attr_reader :seeds, :overlap, :radius, :rotation, :live_visitor
    attr_accessor :extent

    def grower
      Grower.new(particles, radius, overlap, extent)
    end

    def add_particle(new_particle, stuck_particle = nil)
      particles << new_particle
      stuck_particle.add_child(new_particle) if stuck_particle
      accept_particle(new_particle, &live_visitor)
      check_bounds(new_particle)
    end

    def check_bounds(particle)
      self.extent = extent.max(particle.extent)
    end

    def accept_particle(particle, &visitor)
      return unless visitor
      visitor.call(transformed_particle(particle))
    end

    def transformed_particle(particle)
      return particle if rotation.zero?
      particle.rotate(rotation)
    end

end
