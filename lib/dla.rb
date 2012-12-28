require "#{File.dirname(__FILE__)}/particle.rb"

class Dla

  def initialize(renderer, *seeds)
    raise ArgumentError if seeds.empty?

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

