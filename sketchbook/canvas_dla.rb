require_relative "../app/dla.rb"
require_relative "./renderer.rb"

def setup
  puts({dimensions: dimensions, radius: radius}.inspect)

  size *dimensions
  background 0

  @dla = new_dla
end

def draw
  @dla.grow
  puts @dla.size if @dla.size % 250 == 0
end

###

CANVAS_DIMENSIONS = [60, 48] # inches
PARTICLE_DIAMETER = 4 # millimeters
VIEWPORT_DIMENSIONS = [1280, 720] # 720p

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

def new_dla
  @dla = Dla.new(radius: radius, overlap: radius / 1000) do |particle|
    Renderer.new(self, particle).render
  end
end
