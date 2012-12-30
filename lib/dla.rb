class Dla

  def initialize(options={})
    @renderer = options.fetch(:renderer)
    @grower = options.fetch(:grower)
    @seeds = Array(options.fetch(:seeds))

    @particles = @seeds.dup

    render_all
  end

  def grow
    new_particle = grower.grow(seeds)
    render(new_particle)
  end

  protected

  attr_reader :renderer, :grower, :seeds, :particles

  def render(particle)
    renderer.render(particle)
  end

  def render_all
    seeds.each { |seed| render(seed) }
  end

end

