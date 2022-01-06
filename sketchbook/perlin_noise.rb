require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/vector2d'
require_relative '../app/dcel/mesh_svg_file'
require_relative '../app/quadtree'

require_relative '../app/point_distributions/point_cloud'
require_relative '../app/point_distributions/point_cloud_svg_file'
require_relative '../app/axis_aligned_bounding_box'

require 'pry'


class PerlinNoise
  def initialize(cell_count)
    @cell_count = cell_count.to_f
  end

  def value(x, y)
    x0, x1 = grid_interval(x)
    y0, y1 = grid_interval(y)

    wx = x - x0
    wy = y - y0

    interpolate(
      interpolate(grid_dot(x0, y0, x, y), grid_dot(x1, y0, x, y), wx),
      interpolate(grid_dot(x0, y1, x, y), grid_dot(x1, y1, x, y), wx),
      wy
    )
  end

  private
  attr_reader :cell_count

  def grid_dot(xi, yi, x, y)
    dot(grid(xi, yi), [x, y])
  end

  def grid(x, y)
    return [1, 2] # TODO
  end

  def dot(v0, v1)
    v0[0]*v1[0] + v0[1]*v1[1]
  end

  def interpolate(v0, v1, w)
    ((1.0 - w) * v0) + (w * v1)
  end

  def grid_interval(value)
    v0 = (value * cell_count).floor / cell_count
    v1 = v0 + (1 / cell_count)

    [v0, v1]
  end
end

perlin_noise = PerlinNoise.new(3)

(0.0..1.0).step(0.1).each do |x|
  (0.0..1.0).step(0.1).each do |y|
    puts "(#{x}, #{y}): #{perlin_noise.value(x, y)}"
  end
end


# point_cloud = PointCloud.new(
#   bounding_box: AxisAlignedBoundingBox.new(-500..500, -700..700),
#   minimum_separation_function: ->(point) { 40 }
# )
#
# triangulation = Triangulation::DelaunayTriangulation.new(point_cloud.points)
#
# puts "\ntriangulating..."
#
# DCEL::MeshSVGFile.new(
#   triangulation,
#   filename: "data/perlin.svg"
# ).save
