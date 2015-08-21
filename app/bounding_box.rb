require_relative "axis_aligned_bounding_box"
require_relative "edge"
require_relative "transformation"
require_relative "../lib/ranges/range_intersection_calculator"
require_relative "../lib/ranges/range_segmenter"
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

  def axis_aligned
    axis_aligned_bounding_box
  end

  def self.from_vertices(vertices)
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

  def vertices
    axis_aligned_bounding_box.vertices.map { |vertex| vertex.rotate(rotation) + offset }
  end

  def fits_within?(box)
    axis_aligned_bounding_box.fits_within?(box.axis_aligned)
  end

  protected

    attr_reader :offset, :rotation, :axis_aligned_bounding_box

    def offset_bounding_box
      axis_aligned_bounding_box + offset
    end

end
