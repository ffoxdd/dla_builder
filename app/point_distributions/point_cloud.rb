require "forwardable"

class PointCloud

  extend Forwardable

  def initialize(boundary:)
    @boundary = boundary
    @points = []
    @failure_count = 0

    generate_points # for whatever reason things are just simpler if this goes here
  end

  attr_reader :points
  delegate [:size, :origin] => :boundary

  private
  attr_reader :boundary
  attr_accessor :failure_count

  MAX_POINTS = 500
  MINIMUM_SEPARATION = 30
  MAX_FAILURES = 2500

  def generate_points
    catch (:saturated) do
      MAX_POINTS.times { points.push(new_point) }
    end
  end

  def new_point
    loop do
      point = boundary.sample_point

      if properly_separated?(point)
        reset_failure_count
        return point
      else
        mark_failure
      end
    end
  end

  def reset_failure_count
    self.failure_count = 0
  end

  def mark_failure
    self.failure_count += 1
    throw(:saturated) if failure_count > MAX_FAILURES
  end

  def properly_separated?(point)
    return true if points.empty?
    distance_to_closest_existing_point(point) > MINIMUM_SEPARATION
  end

  def distance_to_closest_existing_point(point) # TODO: consider using a quadtree
    points.map { |p| p.distance(point) }.min
  end

end
