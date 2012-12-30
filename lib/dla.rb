require "#{File.dirname(__FILE__)}/particle.rb"

class Dla

  def initialize(options={})
    @renderer = options.fetch(:renderer)
    @grower = options.fetch(:grower)
    @seeds = Array(options.fetch(:seeds))

    render_seeds
  end

  def grow
    new_particle = grower.grow(seeds)
    renderer.render(new_particle)
  end

  protected

  attr_reader :renderer, :grower, :seeds

  def render_seeds
    seeds.each { |seed| renderer.render(seed) }
  end

end

