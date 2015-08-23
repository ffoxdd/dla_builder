require_relative "../app/dla.rb"
require_relative "../app/canvas.rb"
require_relative "./renderer.rb"

CANVAS_DIMENSIONS = [1.75, 0.75].map { |x| x * 8 } # inches
VIEWPORT_DIMENSIONS = [1280, 720].map { |x| x * 2 } # 720p
PARTICLE_DIAMETER = 0.0175 # inches

def setup
  size *canvas.sketch_dimensions
  background 255
end

def draw
  grow
end

def keyPressed
  save(filename)
end

private

def grow
  dla.grow
  notify_progress
end

def notify_progress
  return unless dla.size % 50 == 0
  puts dla.size
end

def dla
  @dla ||= Dla.new(particle_radius: particle_radius, overlap: overlap) do |particle|
    Renderer.new(self, particle, fill_color: 0).render
  end
end

def particle_radius
  canvas.inches_to_pixels(PARTICLE_DIAMETER) / 2
end

def overlap
  particle_radius / 2
end

def canvas
  @canvas ||= Canvas.new(VIEWPORT_DIMENSIONS, CANVAS_DIMENSIONS)
end

def filename
  description_string = [
    CANVAS_DIMENSIONS.join("x"),
    "p#{PARTICLE_DIAMETER}",
    "n#{dla.size}"
  ].join("_")

  "data/stamp_2/stamp_#{description_string}.jpg"
end
