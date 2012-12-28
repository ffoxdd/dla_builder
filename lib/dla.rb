require "#{File.dirname(__FILE__)}/particle.rb"

class Dla

  def initialize(renderer, particle_source, *seeds)
    raise ArgumentError if seeds.empty?

    @renderer = renderer
    @particle_source = particle_source
    @seeds = seeds

    render_seeds
  end

  def grow
    @particle_source.new

    # spawn a new particle on the spawning circle | Particle#new(0, 0) | Particle#step
    # walk the particle | Particle#step
    # if it goes outside the kill radius, kill it | Particle#reset
    # if it sticks, stop
  end

  protected

  attr_reader :renderer, :seeds

  def render_seeds
    seeds.each { |seed| renderer.render(seed) }
  end

end

