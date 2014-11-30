require_relative "../app/dla.rb"
require_relative "../app/convex_hull.rb"
require_relative "./renderer.rb"

def setup
  size 800, 600
  background 0

  @dla = Dla.new do |particle, dla|
    render(particle)
    render_convex_hull(dla.convex_hull)
  end
end

def draw
  @dla.grow
end

def render(particle)
  # Renderer.new(self, particle).render
end

def render_convex_hull(convex_hull)
  noFill
  stroke(255)

  beginShape
  convex_hull.points.each { |point| vertex(x(point.x), y(point.y)) }
  endShape(CLOSE)
end

def x(x_)
  width / 2 + x_
end

def y(y_)
  height / 2 + y_
end
