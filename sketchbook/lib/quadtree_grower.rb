class QuadtreeGrower

  def initialize(options = {})
    @particles = options.fetch(:particles)
    @particle_source = options.fetch(:particle_source) { Particle }
    @radius = Float(options.fetch(:radius) { 10 })
    @overlap = Float(options.fetch(:overlap) { 0.2 })

    @neighborhood_radius = Float(options.fetch(:neighborhood_radius) { 50 })
  end

  def grow
    spawn
    step until stuck?
    test_particle
  end

  protected

  attr_reader :particle_source, :particles, :overlap, :radius, :neighborhood_radius
  attr_accessor :test_particle, :closest_particle
  attr_writer :closest_distance

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
    return false unless closest_particle
    test_particle.distance(closest_particle) <= 0
  end

  def step_distance
    closest_distance + overlap
  end

  def spawning_radius
    extent * 2
  end

  def kill_radius
    spawning_radius * 2
  end

  def extent
    particles.map(&:extent).max
  end

  def calculate_closest
    self.closest_particle = closest_neighborhood_particle
    self.closest_distance = (test_particle.distance(closest_particle) if closest_particle)
  end

  def neighborhood_range(center)
    (center - neighborhood_radius / 2)..(center + neighborhood_radius / 2)
  end

  def neighborhood_particles
    particles.within(neighborhood_range(test_particle.x), neighborhood_range(test_particle.y))
  end

  def closest_neighborhood_particle
    neighborhood_particles.min_by { |particle| test_particle.distance(particle) }
  end

  def closest_distance
    @closest_distance || neighborhood_radius
  end

  def too_far?
    test_particle.extent > kill_radius
  end

end
