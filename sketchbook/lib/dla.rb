require File.join(File.dirname(__FILE__), "particle")
require File.join(File.dirname(__FILE__), "quadtree")
require File.join(File.dirname(__FILE__), "persister")
require File.join(File.dirname(__FILE__), "linear_grower")

class Dla

  def initialize(options = {})
    @renderer = options.fetch(:renderer) { Renderer.new }
    @grower_source = options.fetch(:grower_source) { LinearGrower }
    @persister = options.fetch(:persister) { Persister }
    @radius = Float(options.fetch(:radius) { 4 })
    @seeds = Array(options.fetch(:seeds) { default_seeds })
    @overlap = Float(options.fetch(:overlap) { @radius / 8.0 })
    @particles = @seeds.dup

    @quadtree = Quadtree.new(-1000..1000, -1000..1000)
    particles.each { |particle| quadtree.add(particle) }

    @extent = 0
    @x_extent = 0
    @y_extent = 0

    check_bounds(@particles)
    render(@particles)
  end

  attr_writer :renderer

  def grow
    new_particle = grower.grow
    check_bounds(new_particle)
    add_particle(new_particle)
  end

  def size
    particles.size
  end

  def save(name)
    persister.save(self, name)
  end

  def within_bounds?(x_range, y_range)
    x_range.include?(@x_extent) && y_range.include?(@y_extent)
  end

  def render(rendered_particles = particles)
    Array(rendered_particles).each { |particle| renderer.render(particle) }
  end

  private

  attr_reader :renderer, :grower_source, :persister, :seeds, :particles, 
    :quadtree, :overlap, :radius

  def grower
    grower_source.new(:particles => particles, :overlap => overlap, :radius => radius)
  end

  def add_particle(particle)
    particles.push(particle)
    quadtree.add(particle)
    render(particle)
  end

  def default_seeds
    [Particle.new(0, 0, radius)]
  end

  def check_bounds(particles)
    Array(particles).each do |particle|
      @extent = [@extent, particle.extent].max
      @x_extent = [@x_extent, particle.x_extent].max
      @y_extent = [@y_extent, particle.y_extent].max
    end
  end

  class Renderer
    def render(particle)
    end
  end

end
