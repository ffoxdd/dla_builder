require 'forwardable'

class Renderer

  extend Forwardable

  def initialize(sketch, particle, options = {})
    @sketch = sketch
    @particle = particle

    @fill_color = options.fetch(:fill_color, 255)
  end

  def render
    settings
    ellipse x(particle), y(particle), radius, radius
  end

  private

    attr_reader :sketch, :particle, :fill_color
    def_delegators :sketch, :noStroke, :smooth, :ellipseMode, :ellipse, :width, :height, :fill, :color

    def settings
      noStroke
      smooth
      ellipseMode(sketch.class::RADIUS)
      fill(fill_color)
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

    def radius
      particle.radius rescue 1
    end
end
