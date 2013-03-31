require File.join(File.dirname(__FILE__), "lib", "dla")

# TODO: encapsulate canvas <-> viewport coordinate system in an object

CANVAS_DIMENSIONS = [60, 48] # inches
PARTICLE_DIAMETER = 5 # millimeters
VIEWPORT_DIMENSIONS = [1200, 700] # pixels

MM_PER_IN = 25.4

def aspect_ratio(dimensions)
  dimensions[0].to_f / dimensions[1].to_f
end

def pixels_per_inch
  canvas_aspect_ratio = aspect_ratio(CANVAS_DIMENSIONS)
  viewport_aspect_ratio = aspect_ratio(VIEWPORT_DIMENSIONS)

  if canvas_aspect_ratio > viewport_aspect_ratio # canvas is wider
    VIEWPORT_DIMENSIONS[0].to_f / CANVAS_DIMENSIONS[0].to_f
  else # canvas is taller
    VIEWPORT_DIMENSIONS[1].to_f / CANVAS_DIMENSIONS[1].to_f
  end
end

def dimensions
  CANVAS_DIMENSIONS.map { |n| n * pixels_per_inch }
end

def radius
  particle_diameter_inches = PARTICLE_DIAMETER / MM_PER_IN
  particle_diameter_inches * pixels_per_inch
end

def setup
  puts({:dimensions => dimensions, :radius => radius}.inspect)
  
  size *dimensions
  background 0

  noStroke
  smooth
  ellipseMode(RADIUS)

  @dla = Dla.new(:renderer => Renderer.new, :radius => radius, :overlap => radius / 1000)
end

def draw
  @dla.grow

  puts @dla.size if @dla.size % 250 == 0
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
