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

(0..160).step(10).each do |inner_inflation|

  frame = Frame.new(
    Vector2D[240, 440], Vector2D[500, 700],
    inner_resolution: 20, outer_resolution: 20
  )

  point_cloud = PointCloud.new(
    bounding_box: frame.bounding_box,
    seeds: frame.points,
    minimum_separation_function: ->(point) {
      progress = frame.inner_progress(point)
      next Float::INFINITY if progress <= 0
      20 + ((0.5 - (0.5 - progress).abs) * inner_inflation)
    }
  )

  triangulation = Triangulation::DelaunayTriangulation.new(point_cloud.points)

  puts "\ntriangulating..."

  DCEL::MeshSVGFile.new(
    triangulation,
    filename: "data/inner_inflation_b/inner_inflation_#{inner_inflation}.svg"
  ).save

  puts "done."

end
