require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/vector2d'
require_relative '../app/dcel/mesh_svg_file'
require_relative '../app/quadtree'

require_relative '../app/point_distributions/point_cloud'
require_relative '../app/point_distributions/point_cloud_svg_file'
require_relative '../app/axis_aligned_bounding_box'

require 'pry'

class Frame
  def initialize(inner_half_width, outer_half_width, inner_resolution: 10, outer_resolution: 10)
    @inner_half_width = inner_half_width.abs
    @outer_half_width = outer_half_width.abs
    @inner_resolution = inner_resolution
    @outer_resolution = outer_resolution
  end

  def inner_progress(point)
    inner_magnitude(point) / max_magnitude.to_f
  end

  def points
    Rectangle.new(inner_half_width, resolution: inner_resolution).points +
    Rectangle.new(outer_half_width, resolution: outer_resolution).points
  end

  def bounding_box
    x, y = outer_half_width.abs.to_a
    AxisAlignedBoundingBox.new(-x..x, -y..y)
  end

  private
  attr_reader :inner_half_width, :outer_half_width, :inner_resolution, :outer_resolution

  def max_magnitude
    @max_magnitude ||= inner_magnitude(outer_half_width)
  end

  def inner_magnitude(point)
    (point.abs - inner_half_width).to_a.max
  end

  class Rectangle
    def initialize(half_width, resolution: 10)
      @half_width = half_width
      @resolution = resolution
    end

    def points
      x, y = half_width.x, half_width.y

      [
        (-x..x).step(resolution).map { |x_| Vector2D[x_, -y] },
        (-x..x).step(resolution).map { |x_| Vector2D[x_, y ] },
        (-y..y).step(resolution).map { |y_| Vector2D[-x, y_] },
        (-y..y).step(resolution).map { |y_| Vector2D[x,  y_] }
      ].flatten.uniq
    end

    private
    attr_reader :half_width, :resolution
  end
end

(10..160).step(10).each do |vertical_increase|

  minimum_separation_function = ->(point) {
    progress = (point.y + 700) / 1400.0
    20 + (progress * vertical_increase)
  }

  bottom_separation = 20 + vertical_increase
  bottom_resolution = [10, 20, 25, 50, 100].select { |r| r <= bottom_separation }.max

  top_frame_points = (-500..500).step(20).map { |x| Vector2D[x, -700] }
  bottom_frame_points = (-500..500).step(bottom_resolution).map { |x| Vector2D[x, 700] }

  side_y_coordinates = []
  current_y_coordinate = 700

  while current_y_coordinate > -680 do
    side_y_coordinates << current_y_coordinate
    current_y_coordinate -= minimum_separation_function.call(Vector2D[0, current_y_coordinate])
  end

  side_y_coordinates << -700
  side_y_coordinates

  side_frame_points = side_y_coordinates.flat_map { |y| [Vector2D[-500, y], Vector2D[500, y]] }

  frame_points = (top_frame_points + bottom_frame_points + side_frame_points).uniq


  point_cloud = PointCloud.new(
    bounding_box: AxisAlignedBoundingBox.new(-500..500, -700..700),
    seeds: frame_points,
    minimum_separation_function: minimum_separation_function
  )

  triangulation = Triangulation::DelaunayTriangulation.new(point_cloud.points)

  puts "\ntriangulating..."

  DCEL::MeshSVGFile.new(
    triangulation,
    filename: "data/gradient/gradient_#{vertical_increase}.svg"
  ).save

  puts "done."

end
