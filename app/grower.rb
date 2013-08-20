class Grower

  def initialize(particles, radius, overlap, extent, options = {})
    @particles = particles
    @radius = radius
    @overlap = overlap
    @extent = extent
    
    @particle_source = options.fetch(:particle_source) { Particle }
  end

  def grow
    spawn
    step until stuck?
    test_particle
  end

  protected

  attr_reader :particle_source, :particles, :overlap, :radius, :extent
  attr_accessor :test_particle, :closest_particle

  def spawn
    self.test_particle = particle_source.new(0, 0, radius)
    test_particle.step(spawning_radius)
    find_closest_particle
  end

  def step
    test_particle.step(step_distance)
    find_closest_particle
    spawn if too_far?
  end

  def find_closest_particle
    self.closest_particle = particles.closest_particle(test_particle)
  end

  def stuck?
    closest_distance <= 0
  end

  def closest_distance
    test_particle.distance(closest_particle)
  end

  def step_distance
    closest_distance + overlap
  end

  def spawning_radius
    extent + (radius * 6)
  end

  def kill_radius
    spawning_radius * 2
  end

  def too_far?
    test_particle.extent > kill_radius
  end

end
