require 'forwardable'

class Renderer

  extend Forwardable

  def initialize(sketch, particle)
    @sketch = sketch
    @particle = particle
  end

  def render
    settings
    ellipse x(particle), y(particle), particle.radius, particle.radius
  end

  private

    attr_reader :sketch, :particle
    def_delegators :sketch, :noStroke, :smooth, :ellipseMode, :ellipse, :width, :height, :fill

    def settings
      noStroke
      smooth
      ellipseMode(sketch.class::RADIUS)
      fill(255)
    end

    def x(particle)
      x_origin + particle.x
    end

    def y(particle)
      y_origin + particle.y
    end

    def x_origin
      width / 2
    end

    def y_origin
      height / 2
    end

end
