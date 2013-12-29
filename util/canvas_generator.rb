require_relative '../app/dla.rb'
require_relative '../app/canvas.rb'

CANVAS_DIMENSIONS = [60, 48] # inches
PARTICLE_DIAMETER = 10 # millimeters
VIEWPORT_DIMENSIONS = [1280, 720] # 720p
SIZE_LIMIT = 2000

canvas = Canvas.new(VIEWPORT_DIMENSIONS, CANVAS_DIMENSIONS)
radius = canvas.mm_to_pixels(PARTICLE_DIAMETER) / 2

(1..1000).each do |n|
  dla_index = "%03d" % n
  print "growing dla #{dla_index} "

  dla = Dla.new(radius: radius)

  while dla.size <= SIZE_LIMIT
    dla.grow
    print '.' if (dla.size % 100).zero?
  end

  dla.save "canvas_60in-48in-10mm_#{dla_index}"
  puts " done."
end
