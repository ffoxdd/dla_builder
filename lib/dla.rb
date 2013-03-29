class Dla

  def initialize(options={})
    @renderer = options[:renderer] || Renderer.new
    @grower_source = options[:grower_source] || Grower
    @radius = Float(options.fetch(:radius, 4))
    @seeds = Array(options.fetch(:seeds, default_seeds))
    @overlap = Float(options.fetch(:overlap, @radius / 8.0))
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

  private

  attr_reader :renderer, :seeds, :particles, :grower_source, :overlap, :radius

  def grower
    grower_source.new(particles, :overlap => overlap, :radius => radius)
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

  def default_seeds
    [ Particle.new(0, 0, @radius) ]
  end

  class Renderer
    def render(particle)
    end
  end

end
