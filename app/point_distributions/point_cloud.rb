require "forwardable"
require_relative "../quadtree"

class PointCloud

  extend Forwardable

  def initialize(
    bounding_box:,
    seeds: [],
    minimum_separation_function: ->(point){ DEFAULT_MINIMUM_SEPARATION } )

    @bounding_box = bounding_box
    @seeds = seeds
    @minimum_separation_function = minimum_separation_function
  end

  def points
    @points ||= points_enumerator.take(MAX_POINTS)
  end

  delegate [:size, :origin] => :bounding_box
  delegate [:each] => :points

  private
  attr_reader :bounding_box, :seeds, :minimum_separation_function
  attr_accessor :failure_count

  MAX_POINTS = 50_000
  MAX_FAILURES = 1_000
  DEFAULT_MINIMUM_SEPARATION = 30

  def points_enumerator
    Enumerator.new do |y|
      seeds.each { |point| add(y, point) }
      failure_count = 0

      loop do
        break if failure_count > MAX_FAILURES

        bounding_box.sample_point.tap do |point|
          next(failure_count += 1) if !properly_separated?(point)
          print("#{failure_count}, "); failure_count = 0
          add(y, point)
        end
      end
    end
  end

  def add(y, point)
    points_collection << point
    y << point
  end

  def points_collection
    @points_collection ||= Quadtree.new(bounding_box)
  end

  def properly_separated?(point)
    return true unless closest_point = points_collection.closest_point(point)
    closest_point.distance(point) > minimum_distance(point)
  end

  def minimum_distance(point)
    minimum_separation_function.call(point)
  end

end
