require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/vector2d'
require_relative '../app/dcel/mesh_svg_file'
require_relative '../app/quadtree'

require_relative '../app/point_distributions/point_cloud'
require_relative '../app/point_distributions/point_cloud_svg_file'
require_relative '../app/axis_aligned_bounding_box'

class Frame
  def initialize(inner_half_width, outer_half_width)
    @inner_half_width = inner_half_width.abs
    @outer_half_width = outer_half_width.abs
  end

  def inner_progress(point)
    inner_magnitude(point) / max_magnitude.to_f
  end

  def points
    (
      Rectangle.new(inner_half_width).points +
      Rectangle.new(outer_half_width).points
    ).uniq
  end

  def bounding_box
    x, y = outer_half_width.abs.to_a
    AxisAlignedBoundingBox.new(-x..x, -y..y)
  end

  private
  attr_reader :inner_half_width, :outer_half_width

  def max_magnitude
    @max_magnitude ||= inner_magnitude(outer_half_width)
  end

  def inner_magnitude(point)
    (point.abs - inner_half_width).to_a.max
  end

  class Rectangle
    def initialize(half_width)
      @half_width = half_width
    end

    STEP = 20

    def points
      x, y = half_width.x, half_width.y

      [
        (-x..x).step(STEP).map { |x_| Vector2D[x_, -y] },
        (-x..x).step(STEP).map { |x_| Vector2D[x_, y ] },
        (-y..y).step(STEP).map { |y_| Vector2D[-x, y_] },
        (-y..y).step(STEP).map { |y_| Vector2D[x,  y_] }
      ].flatten
    end

    private
    attr_reader :half_width
  end
end

frame = Frame.new(Vector2D[100, 200], Vector2D[250, 350])

point_cloud = PointCloud.new(
  bounding_box: frame.bounding_box,
  seeds: frame.points,
  minimum_separation_function: ->(point) {
    progress = frame.inner_progress(point)
    next Float::INFINITY if progress <= 0
    15 + ((0.5 - (0.5 - progress).abs) * 40)
  }
)

# PointCloudSVGFile.new(point_cloud).save

triangulation = Triangulation::DelaunayTriangulation.new(point_cloud.points)

puts "triangulating..."
DCEL::MeshSVGFile.new(triangulation, filename: "data/triangulated_frame.svg").save
puts "done."
