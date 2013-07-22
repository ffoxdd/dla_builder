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

  def neighborhood_radius(zoom_factor = 1)
    @neighborhood_radius * zoom_factor
  end

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
    return false unless closest_particle
    test_particle.distance(closest_particle) <= 0
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

  def find_closest_particle_within_neighborhood(zoom_factor)
    self.closest_particle = closest_neighborhood_particle(zoom_factor)
    self.closest_distance = (test_particle.distance(closest_particle) if closest_particle)

    reset_closest_particle_information if false_closest_particle?(zoom_factor)
  end

  def false_closest_particle?(zoom_factor)
    closest_distance > neighborhood_radius(zoom_factor)
  end

  def find_closest_particle
    reset_closest_particle_information
    zoom_factor = 1

    begin
      find_closest_particle_within_neighborhood(zoom_factor)
      zoom_factor += 1
    end until closest_particle_found?
  end

  def reset_closest_particle_information
    self.closest_particle = nil
    self.closest_distance = nil
  end

  def closest_particle_found?
    !!self.closest_particle
  end

  def neighborhood_range(center, zoom_factor)
    (center - search_radius(zoom_factor))..(center + search_radius(zoom_factor))
  end

  def search_radius(zoom_factor)
    neighborhood_radius(zoom_factor) + radius
  end

  def neighborhood_particles(zoom_factor)
    particles.within(neighborhood_range(test_particle.x, zoom_factor), neighborhood_range(test_particle.y, zoom_factor))
  end

  def closest_neighborhood_particle(zoom_factor)
    neighborhood_particles(zoom_factor).min_by { |particle| test_particle.distance(particle) }
  end

  def closest_distance
    @closest_distance || neighborhood_radius
  end

  def too_far?
    test_particle.extent > kill_radius
  end

end
