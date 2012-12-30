class Dla

  def initialize(options={})
    @renderer = options.fetch(:renderer)
    @grower = options.fetch(:grower)
    @seeds = Array(options.fetch(:seeds))

    @particles = @seeds.dup

    render_all
  end

  def grow
    new_particle = grower.grow(particles)
    add_particle(new_particle)
  end

  def size
    particles.size
  end

  protected

  attr_reader :renderer, :grower, :seeds, :particles

  def render(particle)
    renderer.render(particle)
  end

  def render_all
    particles.each { |particle| render(particle) }
  end

  def add_particle(particle)
    particles.push(particle)
    render(particle)
  end

end

