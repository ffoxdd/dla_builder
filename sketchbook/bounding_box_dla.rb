require_relative "../app/dla.rb"
require_relative "../app/convex_hull.rb"
require_relative "../app/bounding_box_finder.rb"
require_relative "./renderer.rb"

def setup
  size 800, 600
  background 0

  @dla = Dla.new do |particle, dla|
    render_particle(particle)
    render_bounding_box(dla.bounding_box)
  end
end

def draw
  @dla.grow
end

def render_particle(particle)
  Renderer.new(self, particle).render
end

def render_bounding_box(bounding_box)
  return unless bounding_box
  noFill
  stroke(255)

  beginShape
  bounding_box.vertices.each { |point| vertex(x(point.x), y(point.y)) }
  endShape(CLOSE)
end

def x(x_)
  width / 2 + x_
end

def y(y_)
  height / 2 + y_
end
