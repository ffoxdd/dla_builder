require_relative 'vector2d'

class Transformation

  def initialize(options = {})
    rotation = options.fetch(:rotation) { 0 }
    translation = options.fetch(:translation) { Vector2D[0, 0] }

    # rotations are applied first
    @transformation_matrix = translation_matrix(translation) * rotation_matrix(rotation)
  end

  def apply(vector)
    Vector2D.new (transformation_matrix * vector.to_m.t).t
  end

  private
  attr_reader :transformation_matrix

  def rotation_matrix(theta)
    Matrix[
      [Math.cos(theta), -Math.sin(theta), 0],
      [Math.sin(theta), Math.cos(theta),  0],
      [0               , 0,               1]
    ]
  end

  def translation_matrix(translation)
    m2 = Matrix[
      [1, 0, translation[0]],
      [0, 1, translation[1]],
      [0, 0, 1             ]
    ]
  end

end
