require_relative "../app/dla.rb"
require_relative "../app/convex_hull.rb"
require_relative "./renderer.rb"

def setup
  size 800, 600
  background 0

  @dla = Dla.new
end

def draw
  @dla.grow
  clear
  render_dla
  render_bounding_box
end

def render_dla
  @dla.accept(center: false) do |particle|
    render_particle(particle)
  end
end

def bounding_box
  @dla.bounding_box
end

def centering_transformation
  bounding_box.centering_transformation
end

def vertices
  bounding_box.vertices
end

def centered_vertices
  vertices.each.map do |point|
    v = center_vector(point.to_v)
    Point.new(v.to_a)
  end
end

def center_vector(v)
  v = (v - bounding_box.send(:offset)).rotate(-bounding_box.send(:rotation))
  v - bounding_box.send(:axis_aligned_bounding_box).center
end

def center_point(point)
  v = center_vector(point.to_v)
  Point.new(v.to_a)
end

def center_particle(particle)
  Particle.new(center: center_point(particle.center), radius: particle.radius)
end

def x(x_)
  width / 2 + x_
end

def y(y_)
  height / 2 + y_
end

def render_particle(particle)
  Renderer.new(self, center_particle(particle)).render
end

def render_rect(points)
  noFill
  stroke(255)

  beginShape
  points.each { |point| vertex(x(point.x), y(point.y)) }
  endShape(CLOSE)
end
