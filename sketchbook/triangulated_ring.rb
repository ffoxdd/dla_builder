require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/vector2d'
require_relative '../app/dcel/mesh_svg_file'
require_relative '../app/quadtree'

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
    )
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

50.times do |n|
  steps = (0..200).step(25).map do |r|
    {radius: r, separation: rand(10..50)}
  end

  ring_distribution = RingDistribution.new(
    bounding_box: AxisAlignedBoundingBox.new(-250..250, -250..250),
    radius_separation_configuration: steps
  )

  point_cloud = PointCloud.new(
    bounding_box: AxisAlignedBoundingBox.new(-200..200, -200..200),
    minimum_separation_function: ring_distribution.method(:separation_function)
  )

  triangulation = Triangulation::DelaunayTriangulation.new(point_cloud)

  puts "data/triangulated_rings/ring_#{n}.svg"

  DCEL::MeshSVGFile.new(
    triangulation,
    filename: "data/triangulated_rings/ring_#{n}.svg"
  ).save
end
