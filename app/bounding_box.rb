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

    translation = input_box.offset + options.fetch(:translation) { Vector2D[0, 0] }
    rotation = options.fetch(:rotation, 0)

    @axis_aligned_bounding_box = input_box.at_origin
    @transformation = Transformation.new(rotation: rotation, translation: translation)
  end

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

  def self.from_vertices(vertices)
    VerticesBoundingBoxBuilder.bounding_box(vertices)
  end

  def vertices
    axis_aligned_bounding_box.vertices.map { |vertex| Point.new(transformation.apply(vertex)) }
  end

  def fits_within?(box)
    axis_aligned_bounding_box.fits_within?(box.axis_aligned)
  end

  protected

  attr_reader :axis_aligned_bounding_box, :transformation

  class VerticesBoundingBoxBuilder
    def self.bounding_box(*args)
      new(*args).bounding_box
    end

    def initialize(vertices)
      @vertices = vertices
    end

    def bounding_box
      # TODO: clean this up with private helper methods
      inverse_translation = vertices[0].displacement(Point[0, 0])
      translation = -inverse_translation

      vertices_at_origin = vertices.map { |vertex| vertex + inverse_translation }

      edge_1 = Edge.new(vertices_at_origin[0], vertices_at_origin[1])
      edge_2 = Edge.new(vertices_at_origin[0], vertices_at_origin[3])

      edge_x, edge_y = edge_1.right_handed?(edge_2) ? [edge_1, edge_2] : [edge_2, edge_1]

      x_basis = Edge.new(Point[0, 0], Point[1, 0])

      inverse_rotation = -x_basis.signed_angle_to(edge_x)
      rotation = -inverse_rotation

      x_length = edge_x.length
      y_length = edge_y.length

      BoundingBox.new(0..x_length, 0..y_length, rotation: rotation, translation: translation)
    end

    private
    attr_reader :vertices
  end

end
