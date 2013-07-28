class Grower

  def initialize(options = {})
    @particles = options.fetch(:particles)
    @particle_source = options.fetch(:particle_source) { Particle }
    @radius = Float(options.fetch(:radius) { 10 })
    @overlap = Float(options.fetch(:overlap) { 0.2 })
  end

  def grow
    spawn
    step until stuck?
    test_particle
  end

  protected

  attr_reader :particle_source, :particles, :overlap, :radius
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

  def extent
    particles.map(&:extent).max
  end

  def too_far?
    test_particle.extent > kill_radius
  end

end