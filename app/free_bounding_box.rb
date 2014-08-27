require_relative "bounding_box"
require_relative "edge"
require "matrix"
require "forwardable"

class FreeBoundingBox

  extend Forwardable

  def initialize(x_range, y_range, options = {})
    @bounding_box = BoundingBox.new(x_range, y_range)
    @rotation = options.fetch(:rotation) { 0 }
    @translation = options.fetch(:translation) { Vector2D[0, 0] }
  end

  def_delegators :bounding_box, :perimeter

  def self.from_vertices(vertices)
    translation = vertices[0].displacement(Point[0, 0])
    translated_vertices = vertices.map { |vertex| vertex + translation }

    edge_x = Edge.new(translated_vertices[0], translated_vertices[1])
    edge_y = Edge.new(translated_vertices[1], translated_vertices[2])

    x_basis = Edge.new(Point[0, 0], Point[1, 0])
    rotation = edge_x.angle_between(x_basis)

    x_length = edge_x.length
    y_length = edge_y.length

    FreeBoundingBox.new(0..x_length, 0..y_length, rotation: -rotation, translation: translation * -1)
  end

  attr_reader :bounding_box, :rotation, :translation

  def transformation_matrix
    @transformation_matrix ||= FreeBoundingBox.transformation_matrix(rotation, translation)
  end

  def self.transformation_matrix(rotation, translation)
    Matrix[
      [Math.cos(rotation), -Math.sin(rotation), translation[0]],
      [Math.sin(rotation), Math.cos(rotation), translation[1]],
      [0, 0, 1]
    ]
  end

end
