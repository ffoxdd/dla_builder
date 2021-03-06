require_relative "particle"

class Grower

  def initialize(particles, radius, overlap, extent, options = {})
    @particles = particles
    @radius = radius
    @overlap = overlap
    @extent_radius = extent.magnitude
  end

  def grow
    spawn
    step until stuck?
    yield(test_particle, closest_particle) if block_given?
  end

  protected

    attr_reader :particles, :overlap, :radius, :extent_radius
    attr_accessor :test_particle, :closest_particle

    def spawn
      self.test_particle = Particle.new(radius: radius).step(spawning_radius)
      find_closest_particle
    end

    def step
      self.test_particle = test_particle.step(step_distance)
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
      extent_radius + (radius * 6)
    end

    def kill_radius
      spawning_radius * 2
    end

    def too_far?
      !test_particle.within_radius?(kill_radius)
    end

end
