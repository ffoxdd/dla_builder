class Grower

  def initialize(existing_particles, options={})
    @existing_particles = existing_particles
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

  attr_reader :particle_source, :existing_particles, :overlap, :radius
  attr_accessor :test_particle, :closest_particle, :closest_distance

  def spawn
    self.test_particle = particle_source.new(0, 0, radius)
    test_particle.step(spawning_radius)
    calculate_closest
  end

  def step
    test_particle.step(step_distance)
    calculate_closest
    spawn if too_far?
  end

  def stuck?
    test_particle.distance(closest_particle) <= 0
  end

  def step_distance
    closest_distance + overlap # TODO: write a test that covers this
  end

  def spawning_radius
    extent * 2
  end

  def kill_radius
    spawning_radius * 2
  end

  def extent
    existing_particles.map(&:extent).max
  end

  def calculate_closest
    self.closest_particle = existing_particles.min_by { |p| test_particle.distance(p) }
    self.closest_distance = test_particle.distance(closest_particle)
  end

  def too_far?
    test_particle.extent > kill_radius
  end

end
