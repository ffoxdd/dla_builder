require "#{File.dirname(__FILE__)}/particle.rb"

class Dla

  # Infinity = 1.0 / 0.0

  def initialize(renderer, *seeds)
    @renderer = renderer
    @seeds = seeds

    render_seeds
  end

  # def grow
  # end

  protected

  attr_reader :renderer, :seeds

  def render_seeds
    seeds.each { |seed| renderer.render(seed) }
  end

  def default_seeds
    [Particle.new(0, 0, 1)]
  end

end

