require_relative 'vector2d'

class Transformation

  def initialize(options = {})
    @rotation = options.fetch(:rotation) { 0 }
    @translation = options.fetch(:translation) { Vector2D[0, 0] }
  end

  attr_reader :rotation, :translation

  def ==(rhs)
    rotation == rhs.rotation && translation == rhs.translation
  end

end
