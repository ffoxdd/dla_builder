class Grower

  def initialize(options={})
    @particle_source = options.fetch(:particle_source, Particle)
  end

  def grow(existing_particles, extent)
    new_particle(extent)

    # walk the particle until it sticks
  end

  protected

  attr_reader :particle_source

  def new_particle(extent)
    particle_source.new(*random_spawning_coordinates(extent), 1)
  end

  def random_spawning_coordinates(extent)
    random_coordinates(spawning_radius(extent))
  end

  def spawning_radius(extent)
    extent * 2
  end

  def kill_radius(extent)
    spawning_radius(extent) * 2
  end

  TWO_PI = Math::PI * 2

  def random_theta
    TWO_PI * rand
  end

  def random_coordinates(radius)
    theta = random_theta
    [Math.sin(theta) * radius, Math.cos(theta) * radius]
  end
end

