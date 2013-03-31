require File.join(File.dirname(__FILE__), "lib", "dla")

def setup
  size 800, 600
  background 0

  noStroke
  smooth
  ellipseMode(RADIUS)

  @dla = Dla.new(:renderer => Renderer.new)
end

def draw
  @dla.grow
end

class Renderer

  def render(particle)
    ellipse x(particle), y(particle), particle.radius, particle.radius
  end

  private

  def x(particle)
    x_origin + particle.x
  end

  def y(particle)
    y_origin + particle.y
  end

  def x_origin
    @x_origin ||= width / 2
  end

  def y_origin
    @y_origin ||= height / 2
  end
  
end
