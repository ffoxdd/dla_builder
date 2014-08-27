require_relative "bounding_box"
require "matrix"

class FreeBoundingBox

  def initialize(x_range, y_range, options = {})
    @bounding_box = BoundingBox.new(x_range, y_range)
    @rotation = options.fetch(:rotation) { 0 }
    @translation = options.fetch(:translation) { Vector2D[0, 0] }
  end

  def transformation_matrix
    Matrix[
      [Math.cos(rotation), -Math.sin(rotation), translation[0]],
      [Math.sin(rotation), Math.cos(rotation), translation[1]],
      [0, 0, 1]
    ]
  end

  private

    attr_reader :bounding_box, :rotation, :translation

end
