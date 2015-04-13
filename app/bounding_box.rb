require_relative "axis_aligned_bounding_box"
require_relative "edge"
require_relative "transformation"
require_relative "../lib/range_intersection_calculator"
require_relative "../lib/range_segmenter"
require "forwardable"

class BoundingBox

  extend Forwardable

  def initialize(x_range, y_range, options = {})
    input_box = AxisAlignedBoundingBox.new(x_range, y_range)

    translation = options.fetch(:translation) { Vector2D[0, 0] }
    rotation = options.fetch(:rotation) { 0 }

    input_box_transformation = input_box.transformation
    specified_transformation = Transformation.new(rotation: rotation, translation: translation)

    @axis_aligned_bounding_box = input_box.at_origin
    @transformation = specified_transformation * input_box_transformation
  end

  attr_reader :transformation

  def ==(box)
    transformation == box.transformation &&
    axis_aligned_bounding_box == box.axis_aligned_bounding_box
  end

  def_delegators :axis_aligned_bounding_box, :perimeter

  def axis_aligned
    axis_aligned_bounding_box
  end

  def covers?(point)
    inverse_transformed_point = transformation.inverse.apply(point)
    axis_aligned_bounding_box.covers?(inverse_transformed_point)
  end

  def vertices
    axis_aligned_bounding_box.vertices.map { |vertex| Point.new(transformation.apply(vertex)) }
  end

  def fits_within?(box)
    axis_aligned_bounding_box.fits_within?(box.axis_aligned)
  end

  protected

  attr_reader :axis_aligned_bounding_box

end
