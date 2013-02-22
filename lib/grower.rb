class Grower

  def initialize(existing_particles, options={})
    @existing_particles = existing_particles
    @particle_source = options.fetch(:particle_source, Particle)
  end

  def grow
    particle = new_particle
    closest_particle = closest_particle_to(particle)
    closest_distance = particle.distance(closest_particle)

    until stuck?(particle, closest_particle)
      particle.step(step_distance(closest_distance))
      closest_particle = closest_particle_to(particle)
      closest_distance = particle.distance(closest_particle)
    end
  end

  protected

  attr_reader :particle_source, :existing_particles

  OVERLAP_DISTANCE = 0.2

  def step_distance(closest_distance)
    closest_distance * OVERLAP_DISTANCE
  end

  def closest_particle_to(particle)
    existing_particles.min { |p| particle.distance(p) }
  end

  def new_particle
    particle_source.new(*random_spawning_coordinates, 1)
  end

  def random_spawning_coordinates
    random_coordinates(spawning_radius)
  end

  def spawning_radius
    extent * 2
  end

  def kill_radius
    spawning_radius * 2
  end

  TWO_PI = Math::PI * 2

  def random_theta
    TWO_PI * rand
  end

  def random_coordinates(radius)
    theta = random_theta
    [Math.sin(theta) * radius, Math.cos(theta) * radius]
  end

  def extent
    existing_particles.map(&:extent).max
  end

  def stuck?(particle, closest_particle)
    particle.distance(closest_particle) <= 0
  end

end
