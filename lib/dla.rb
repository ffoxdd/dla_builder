require "#{File.dirname(__FILE__)}/particle.rb"

class Dla

  def initialize(options={})
    @renderer = options.fetch(:renderer)
    @particle_source = options.fetch(:particle_source)
    @seeds = Array(options.fetch(:seeds))

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

