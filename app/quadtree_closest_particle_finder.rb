require_relative "axis_aligned_bounding_box"

class QuadtreeClosestParticleFinder

  def initialize(quadtree, test_particle, particle_radius, options = {})
    @quadtree = quadtree
    @test_particle = test_particle
    @particle_radius = particle_radius
    @neighborhood_radius = options.fetch(:neighborhood_radius, 50)
  end

  def closest_particle
    reset_current_closest_particle
    zoom_factor = 1

    begin
      find_closest_particle_within_neighborhood(zoom_factor)
      zoom_factor += 1
    end until closest_particle_found?

    current_closest_particle
  end

  protected

    attr_reader :quadtree, :test_particle, :neighborhood_radius, :particle_radius
    attr_accessor :current_closest_particle

    def neighborhood_radius(zoom_factor = 1)
      @neighborhood_radius * zoom_factor
    end

    def closest_distance
      return neighborhood_radius unless closest_particle_found?
      test_particle.distance(current_closest_particle)
    end

    def reset_current_closest_particle
      self.current_closest_particle = nil
    end

    def closest_particle_found?
      !!current_closest_particle
    end

    def find_closest_particle_within_neighborhood(zoom_factor)
      self.current_closest_particle = closest_neighborhood_particle(zoom_factor)
      reset_current_closest_particle if false_closest_particle?(zoom_factor)
    end

    def false_closest_particle?(zoom_factor)
      closest_distance > neighborhood_radius(zoom_factor)
    end

    def closest_neighborhood_particle(zoom_factor)
      neighborhood_particles(zoom_factor).min_by { |particle| test_particle.distance(particle) }
    end

    def neighborhood_particles(zoom_factor)
      quadtree.within(neighborhood_bounding_box(zoom_factor))
    end

    def neighborhood_bounding_box(zoom_factor)
      AxisAlignedBoundingBox.new(
        neighborhood_range(test_particle.x, zoom_factor),
        neighborhood_range(test_particle.y, zoom_factor)
      )
    end

    def neighborhood_range(center, zoom_factor)
      (center - search_radius(zoom_factor))..(center + search_radius(zoom_factor))
    end

    def search_radius(zoom_factor)
      neighborhood_radius(zoom_factor) + particle_radius
    end

end
