require File.join(File.dirname(__FILE__), "grower")

class QuadtreeGrower < Grower

  def initialize(options = {})
    super
    @neighborhood_radius = Float(options.fetch(:neighborhood_radius) { 50 })
  end

  protected

  attr_reader :neighborhood_radius

  def neighborhood_radius(zoom_factor = 1)
    @neighborhood_radius * zoom_factor
  end

  def closest_distance
    return neighborhood_radius unless closest_particle
    super
  end

  def find_closest_particle
    reset_closest_particle
    zoom_factor = 1

    begin
      find_closest_particle_within_neighborhood(zoom_factor)
      zoom_factor += 1
    end until closest_particle_found?
  end

  def reset_closest_particle
    self.closest_particle = nil
  end

  def closest_particle_found?
    !!closest_particle
  end

  def find_closest_particle_within_neighborhood(zoom_factor)
    self.closest_particle = closest_neighborhood_particle(zoom_factor)
    reset_closest_particle if false_closest_particle?(zoom_factor)
  end

  def false_closest_particle?(zoom_factor)
    closest_distance > neighborhood_radius(zoom_factor)
  end

  def closest_neighborhood_particle(zoom_factor)
    neighborhood_particles(zoom_factor).min_by { |particle| test_particle.distance(particle) }
  end

  def neighborhood_particles(zoom_factor)
    particles.within(
      neighborhood_range(test_particle.x, zoom_factor), 
      neighborhood_range(test_particle.y, zoom_factor)
    )
  end

  def neighborhood_range(center, zoom_factor)
    (center - search_radius(zoom_factor))..(center + search_radius(zoom_factor))
  end

  def search_radius(zoom_factor)
    neighborhood_radius(zoom_factor) + radius
  end

end
