require_relative "axis_aligned_bounding_box"
require_relative "edge"
require_relative "../lib/range_intersection_calculator"
require_relative "../lib/range_segmenter"
require "forwardable"

class BoundingBox

  extend Forwardable

  def initialize(x_range, y_range, options = {})
    input_box = AxisAlignedBoundingBox.new(x_range, y_range)
    @offset = input_box.offset + options.fetch(:translation) { Vector2D[0, 0] }
    @axis_aligned_bounding_box = input_box.at_origin
    @rotation = options.fetch(:rotation, 0)
  end

  def ==(box)
    offset == box.offset &&
    rotation == box.rotation &&
    axis_aligned_bounding_box == box.axis_aligned_bounding_box
  end

  def_delegators :axis_aligned_bounding_box, :perimeter
  def_delegators :offset_bounding_box, :covers?

  def self.from_vertices(vertices)
    translation = vertices[0].displacement(Point[0, 0])
    vertices_before_translation = vertices.map { |vertex| vertex - translation }

    edge_x = Edge.new(vertices_before_translation[0], vertices_before_translation[1])
    edge_y = Edge.new(vertices_before_translation[1], vertices_before_translation[2])

    x_basis = Edge.new(Point[0, 0], Point[1, 0])
    rotation = x_basis.angle_between(edge_x)
    rotation *= -1 if !x_basis.right_handed?(edge_x)

    x_length = edge_x.length
    y_length = edge_y.length

    BoundingBox.new(0..x_length, 0..y_length, rotation: rotation, translation: translation)
  end

  def vertices
    axis_aligned_bounding_box.vertices.map { |vertex| vertex.rotate(rotation) + offset }
  end

  protected

    attr_reader :offset, :rotation, :axis_aligned_bounding_box

    def offset_bounding_box
      axis_aligned_bounding_box + offset
    end

end
