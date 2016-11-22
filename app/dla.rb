require_relative "particle"
require_relative "grower"
require_relative "persister"
require_relative "particle_collection"

require "forwardable"

class Dla

  extend Forwardable

  def initialize(options = {}, &live_visitor)
    @particle_radius = Float( options.fetch(:particle_radius, 4) )
    @overlap = Float( options.fetch(:overlap) { @particle_radius / 1000.0 } )
    @seeds = Array( options.fetch(:seeds) { [Particle.new(radius: particle_radius)] } )
    @live_visitor = live_visitor

    @particle_collection = ParticleCollection.new(@particle_radius)

    @seeds.each { |seed| add_particle(seed) }
  end

  attr_reader :particle_collection, :convex_hull, :bounding_box

  def grow
    grower.grow do |new_particle, stuck_particle|
      add_particle(new_particle, stuck_particle)
    end
  end

  def accept(options = {}, &visitor)
    transformation = options.fetch(:transformation) { Transformation.new }

    particle_collection.each do |particle|
      accept_particle(particle * transformation, &visitor)
    end
  end

  def size
    particle_collection.size
  end

  def save(name)
    Persister.new(self, name).save
  end

  def_delegators :particle_collection, :fits_within?, :within?

  private

  attr_reader :seeds, :overlap, :particle_radius, :live_visitor
  attr_writer :bounding_box
  def_delegators :particle_collection, :extent # TODO: move this into ParticleCollection

  def grower
    Grower.new(particle_collection, particle_radius, overlap, extent)
  end

  def add_particle(new_particle, stuck_particle = nil)
    particle_collection.add(new_particle, stuck_to: stuck_particle)
    accept_particle(new_particle, &live_visitor)
  end

  def accept_particle(particle, &visitor)
    return unless visitor
    visitor.arity == 1 ? visitor.call(particle) : visitor.call(particle, self)
  end

end
