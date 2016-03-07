require_relative '../app/triangulation/delaunay_triangulation.rb'
require_relative '../app/point'
require_relative '../app/dcel/mesh_svg_file'

require_relative '../app/point_distributions/point_cloud'
require_relative '../app/point_distributions/point_cloud_svg_file'
require_relative '../app/axis_aligned_bounding_box'

point_cloud = PointCloud.new(
  boundary: AxisAlignedBoundingBox.new(-250..250, -250..250),
  minimum_separation_function: ->(point){
    left_side_separation = 15
    right_side_separation = 60
    right_side_separation_increase = right_side_separation - left_side_separation
    distance_from_left_side = point.x - (-250)
    fraction_towards_right_side = distance_from_left_side / 500.0
    separation_increase = fraction_towards_right_side * right_side_separation_increase

    left_side_separation + separation_increase
  }
)

PointCloudSVGFile.new(point_cloud).save
