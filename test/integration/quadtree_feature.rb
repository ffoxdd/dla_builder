require_relative "../test_helper"

require_relative '../../app/axis_aligned_bounding_box'
require_relative '../../app/vector2d'
require_relative '../../app/quadtree'

# class Scenario
#   def valid?
#     closest_point == quadtree_closest_point
#   end
#
#   def s(point)
#     "(#{point.x}, #{point.y})"
#   end
#
#   def closest_point
#     candidate_points.min_by { |point| point.distance(reference_point) }
#   end
#
#   def quadtree_closest_point
#     quadtree.closest_point(reference_point)
#   end
#
#   def reference_point
#     @point ||= sample_point
#   end
#
#   def candidate_points
#     @candidate_points ||= 2.times.map { sample_point }
#   end
#
#   def bounding_box
#     @bounding_box ||= AxisAlignedBoundingBox.new(-500..500, -700..700)
#   end
#
#   def sample_point
#     bounding_box.sample_point
#   end
#
#   def quadtree
#     @quadtree ||= Quadtree.new(bounding_box).tap do |qt|
#       candidate_points.each { |point| qt << point }
#     end
#   end
# end
#
# describe Quadtree do
#   it "works" do
#     500.times do
#       Scenario.new.valid?.must_equal true
#     end
#   end
# end
