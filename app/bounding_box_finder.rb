require_relative "edge"
require_relative "bounding_box"
require_relative "caliper"
require_relative "vertices_bounding_box_builder"
require "forwardable"

class BoundingBoxFinder

  def initialize(polygon)
    @polygon = polygon
    @calipers = []
    @total_rotation = 0

    seed_calipers
    find_bounding_box
  end

  attr_reader :bounding_box

  private

  attr_reader :polygon, :calipers
  attr_accessor :total_rotation
  attr_writer :bounding_box

  def find_bounding_box
    if polygon.degenerate?
      self.bounding_box = degenerate_bounding_box
      return
    end

    until done?
      rotate_calipers
      check_bounding_box
    end
  end

  def rotate_calipers
    angle = closest_angle
    calipers.each { |caliper| caliper.rotate(angle) }
    self.total_rotation = total_rotation + angle
  end

  def done?
    total_rotation > Math::PI / 2
  end

  def seed_calipers
    min_x, min_y = polygon.min_nodes
    max_x, max_y = polygon.max_nodes

    calipers << Caliper.new(min_x, Vector2D[0, 1])
    calipers << Caliper.new(max_y, Vector2D[1, 0])
    calipers << Caliper.new(max_x, Vector2D[0, -1])
    calipers << Caliper.new(min_y, Vector2D[-1, 0])
  end

  def check_bounding_box
    self.bounding_box = current_optimal_bounding_box
  end

  def current_optimal_bounding_box
    return current_bounding_box if !bounding_box
    [current_bounding_box, bounding_box].min_by(&:perimeter)
  end

  def current_bounding_box
    VerticesBoundingBoxBuilder.bounding_box(intersection_points)
  end

  def intersection_points
    [ calipers[0].intersection(calipers[1]), calipers[1].intersection(calipers[2]),
      calipers[2].intersection(calipers[3]), calipers[3].intersection(calipers[0]) ]
  end

  def closest_angle
    calipers.map(&:angle).min
  end

  def degenerate_bounding_box
    point = polygon.points.first
    BoundingBox.new(point.x..point.x, point.y..point.y)
  end

end
