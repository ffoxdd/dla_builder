require_relative "particle"

class TreePropertyCalculator

  def initialize(particles)
    @particles = particles
  end

  def average_depth
    particles.map(&:depth).inject(&:+) / particles.size.to_f
  end

  private

    attr_reader :particles

end
