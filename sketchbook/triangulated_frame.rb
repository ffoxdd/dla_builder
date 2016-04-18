require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/vector2d'
require_relative '../app/dcel/mesh_svg_file'
require_relative '../app/quadtree'

require_relative '../app/point_distributions/point_cloud'
require_relative '../app/point_distributions/point_cloud_svg_file'
require_relative '../app/axis_aligned_bounding_box'

1.times do |n|

  separation_function = ->(point) {
    x, y = point.x.abs, point.y.abs
    next Float::INFINITY if x <= 100 && y <= 200
    extent = [x - 100, y - 200].max
    progress = extent / 150.0 # [0, 1]
    15 + (40 * progress)
  }

  point_cloud = PointCloud.new(
    bounding_box: AxisAlignedBoundingBox.new(-250..250, -350..350),
    minimum_separation_function: separation_function
  )

  inner_boundary_points = [
    (-100..100).step(20).map { |x| Vector2D[x, -200] },
    (-100..100).step(20).map { |x| Vector2D[x, 200] },
    (-200..200).step(20).map { |y| Vector2D[-100, y] },
    (-200..200).step(20).map { |y| Vector2D[100, y] }
  ].flatten.uniq

  outer_boundary_points = [
    (-250..250).step(50).map { |x| Vector2D[x, -350] },
    (-250..250).step(50).map { |x| Vector2D[x, 350] },
    (-350..350).step(50).map { |y| Vector2D[-250, y] },
    (-350..350).step(50).map { |y| Vector2D[250, y] }
  ].flatten.uniq

  points = point_cloud.points.to_a + inner_boundary_points + outer_boundary_points

  triangulation = Triangulation::DelaunayTriangulation.new(points)

  # PointCloudSVGFile.new(
  #   point_cloud, filename: "data/frame_points.svg"
  # )

  DCEL::MeshSVGFile.new(
    triangulation,
    filename: "data/triangulated_frame.svg"
  ).save

end
