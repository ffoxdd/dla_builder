require_relative 'vector2d'

class Transformation

  def initialize(options = {})
    @rotation = options.fetch(:rotation) { 0 }
    @translation = options.fetch(:translation) { Vector2D[0, 0] }
  end

  private
  attr_reader :rotation, :translation

end
