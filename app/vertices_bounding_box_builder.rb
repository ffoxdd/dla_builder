require_relative "bounding_box"

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

    rotation_transformation = Transformation.new(rotation: rotation)
    translation_transformation = Transformation.new(translation: translation)

    transformation = translation_transformation * rotation_transformation

    BoundingBox.new(0..x_length, 0..y_length, transformation: transformation)
  end

  private
  attr_reader :vertices
end
