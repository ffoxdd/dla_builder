require_relative "../app/dla.rb"
require_relative "../app/canvas.rb"
require_relative "./renderer.rb"

CANVAS_DIMENSIONS = [60, 48] # inches
PARTICLE_DIAMETER = 10 # millimeters
VIEWPORT_DIMENSIONS = [1280, 720] # 720p

def setup
  canvas = Canvas.new(VIEWPORT_DIMENSIONS, CANVAS_DIMENSIONS)
  dimensions = canvas.sketch_dimensions
  particle_radius = canvas.mm_to_pixels(PARTICLE_DIAMETER) / 2

  size *dimensions
  background 0

  @dla = Dla.new(particle_radius: particle_radius) do |particle|
    Renderer.new(self, particle).render
  end
end

def draw
  @dla.grow
  puts @dla.size if @dla.size % 250 == 0
end
