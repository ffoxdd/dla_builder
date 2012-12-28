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
  end

  protected

  attr_reader :renderer, :seeds

  def render_seeds
    seeds.each { |seed| renderer.render(seed) }
  end

end

