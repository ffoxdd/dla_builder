require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/point'
require_relative '../app/dcel/mesh_svg_file'

require_relative '../app/point_distributions/point_cloud'
require_relative '../app/point_distributions/point_cloud_svg_file'
require_relative '../app/axis_aligned_bounding_box'

class RingDistribution
  def initialize(bounding_box:, radius_separation_configuration: [])
    @bounding_box = bounding_box
    @radius_separation_configuration = radius_separation_configuration.sort_by { |h| h[:radius] }
  end

  def separation_function(point)
    separation_for_radius(radius(point))
  end

  attr_reader :bounding_box

  private
  attr_reader :radius_separation_configuration

  def separation_for_radius(radius)
    endpoints = interpolation_endpoints(radius)

    if !endpoints
      return min_radius_config[:separation] if radius <= min_radius_config[:radius]
      return max_radius_config[:separation] if radius >= max_radius_config[:radius]
    end

    interpolated_separation(radius, endpoints)
  end

  def min_radius_config
    @min_radius_config ||= radius_separation_configuration.first
  end

  def max_radius_config
    @max_radius_config ||= radius_separation_configuration.last
  end

  def interpolated_separation(radius, endpoints)
    segment_size = endpoints[1][:radius] - endpoints[0][:radius]
    distance_along_segment = radius - endpoints[0][:radius]
    progress_fraction = distance_along_segment / segment_size

    interpolate(
      endpoints[0][:separation],
      endpoints[1][:separation],
      progress_fraction
    )#.tap { |r| require 'pry'; binding.pry if radius < 5 }
  end

  def interpolate(a, b, progress_fraction)
    a_weight = 1 - progress_fraction
    b_weight = progress_fraction

    (a_weight * a) + (b_weight * b)
  end

  def interpolation_endpoints(radius)
    radius_separation_configuration.each_cons(2).find do |previous_config, next_config|
      previous_config[:radius] <= radius && next_config[:radius] > radius
    end
  end

  def radius(point)
    point.distance(center)
  end

  def center
    @center ||= bounding_box.center
  end
end

class FunctionVisualizationSVGFile
  extend Forwardable

  def initialize(function:, bounding_box:, resolution: 75, filename: "function_visualization.svg")
    @function = function
    @bounding_box = bounding_box
    @resolution = resolution
    @filename = filename
  end

  def save
    svg_file.save { |image| draw(image) }
  end

  private
  attr_reader :function, :bounding_box, :resolution, :filename

  def svg_file
    @svg_file ||= SVG::File.new(filename: filename, dimensions: bounding_box.size)
  end

  def t(point)
    point - bounding_box.origin
  end

  def draw(image)
    each_sample { |point, value| draw_value(point, value, image) }
  end

  def draw_value(point, value, image, radius: 3)
    image.circle(*t(point).to_a, radius, stroke: "none", fill: value_color(value))
  end

  def value_color(value)
    rgb_string(rgb_value(value))
  end

  def rgb_string(rgb_value)
    "rgb(#{rgb_value},#{rgb_value},#{rgb_value})"
  end

  def rgb_value(value)
    map_range(value, minmax, [0, 255]).round
  end

  def map_range(value, old_range, new_range)
    old_size = old_range[1] - old_range[0]
    new_size = new_range[1] - new_range[0]
    index = (value - old_range[0]) / old_size.to_f

    new_range[0] + (index * new_size)
  end

  def sampling
    @sampling ||= AreaFunctionSampling.new(
      function: function, bounding_box: bounding_box, resolution: resolution
    )
  end

  delegate [:each_sample, :minmax] => :sampling

  class AreaFunctionSampling
    def initialize(function:, bounding_box:, resolution:)
      @function = function
      @bounding_box = bounding_box
      @resolution = resolution
    end

    def each_sample
      sample_points.each { |point| yield(point, function.call(point)) }
    end

    def minmax
      @minmax ||= sample_points.map { |point| function.call(point) }.minmax
    end

    private
    attr_reader :function, :bounding_box, :resolution

    def sample_points
      @sample_points ||= coordinates.map { |x, y| Point[x, y] }.to_a
    end

    def coordinates
      x_coordinates.to_a.product(y_coordinates.to_a)
    end

    def x_coordinates
      step_over_range(bounding_box.x_range)
    end

    def y_coordinates
      step_over_range(bounding_box.y_range)
    end

    def step_over_range(range)
      range.step(step_size(range))
    end

    def step_size(range)
      (range.end - range.begin) / resolution.to_f
    end
  end
end

ring_distribution = RingDistribution.new(
  bounding_box: AxisAlignedBoundingBox.new(-250..250, -250..250),
  radius_separation_configuration: [
    {radius: 0, separation: 15},
    {radius: 100, separation: 15},
    {radius: 150, separation: 5},
    {radius: 200, separation: 15}
  ]
)

# FunctionVisualizationSVGFile.new(
#   function: ring_distribution.method(:separation_function),
#   bounding_box: ring_distribution.bounding_box
# ).save

point_cloud = PointCloud.new(
  boundary: AxisAlignedBoundingBox.new(-200..200, -200..200),
  minimum_separation_function: ring_distribution.method(:separation_function)
)

PointCloudSVGFile.new(point_cloud).save

triangulation = Triangulation::DelaunayTriangulation.new(point_cloud)
DCEL::MeshSVGFile.new(triangulation).save
