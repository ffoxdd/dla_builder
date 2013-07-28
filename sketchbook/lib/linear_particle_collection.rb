class LinearParticleCollection

  include Enumerable

  def initialize
    @particles = []
  end

  def size
    particles.size
  end

  def <<(particle)
    particles << particle
  end

  def each(&block)
    particles.each(&block)
  end

  def closest_particle(test_particle)
    particles.min_by { |particle| test_particle.distance(particle) }
  end

  private

  attr_reader :particles

end
