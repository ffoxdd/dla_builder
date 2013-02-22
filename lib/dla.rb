class Dla

  def initialize(options={})
    @renderer = options.fetch(:renderer)
    @grower_source = options.fetch(:grower_source, Grower)
    @seeds = Array(options.fetch(:seeds))

    @particles = @seeds.dup

    render_all
  end

  def grow
    new_particle = grower.grow
    add_particle(new_particle)
  end

  def size
    particles.size
  end

  protected

  attr_reader :renderer, :seeds, :particles, :grower_source

  def grower
    grower_source.new(particles)
  end

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

