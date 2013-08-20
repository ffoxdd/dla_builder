require 'forwardable'

class LinearParticleCollection

  include Enumerable
  extend Forwardable

  def_delegators :particles, :size, :<<, :each

  def initialize
    @particles = []
  end

  def closest_particle(test_particle)
    particles.min_by { |particle| test_particle.distance(particle) }
  end

  private

  attr_reader :particles

end
