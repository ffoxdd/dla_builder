require "forwardable"
require_relative "../quadtree"

class PointCloud

  extend Forwardable

  def initialize(
    bounding_box:,
    minimum_separation_function: ->(point){ MINIMUM_SEPARATION } )

    @bounding_box = bounding_box
    @points = Quadtree.new(bounding_box)
    @failure_count = 0
    @minimum_separation_function = minimum_separation_function

    generate_points # for whatever reason things are just simpler if this goes here
  end

  attr_reader :points

  delegate [:size, :origin] => :bounding_box
  delegate [:each] => :points

  private
  attr_reader :bounding_box, :minimum_separation_function
  attr_accessor :failure_count

  MAX_POINTS = 50_000
  MINIMUM_SEPARATION = 30
  # MAX_FAILURES = 10_000
  MAX_FAILURES = 1_000

  def generate_points
    catch (:saturated) do
      MAX_POINTS.times { points << new_point }
    end
  end

  def new_point
    loop do
      point = bounding_box.sample_point

      if properly_separated?(point)
        reset_failure_count
        return point
      else
        mark_failure
      end
    end
  end

  def reset_failure_count
    puts failure_count
    self.failure_count = 0
  end

  def mark_failure
    self.failure_count += 1
    throw(:saturated) if failure_count > MAX_FAILURES
  end

  def properly_separated?(point)
    return true unless closest_point = points.closest_point(point)
    closest_point.distance(point) > minimum_separation_function.call(point)
  end

end
