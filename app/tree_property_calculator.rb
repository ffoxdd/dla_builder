require_relative "particle"

class TreePropertyCalculator

  def initialize(particles)
    @particles = particles
  end

  def average_depth
    average_by(&:depth)
  end

  def max_depth
    max_by(&:depth)
  end

  def average_branching_factor
    average_by { |particle| particle.children.size }
  end

  def max_branching_factor
    max_by { |particle| particle.children.size }
  end

  private

    attr_reader :particles

    def average_by(&block)
      particles.map(&block).inject(&:+) / particles.size.to_f
    end

    def max_by(&block)
      particles.map(&block).max
    end

end
