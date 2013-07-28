require File.join(File.dirname(__FILE__), "grower")

class LinearGrower < Grower

  protected

  def find_closest_particle
    self.closest_particle = particles.min_by { |p| test_particle.distance(p) }
  end

end
