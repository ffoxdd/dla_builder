require_relative '../sketchbook/lib/dla.rb'

100.times do |n|
	print "growing dla #{n}"

	dla = Dla.new(radius: 2.87073490813648)

	until !dla.within_bounds?(-437.5..437.5, -350.0..350.0)
		dla.grow
		print '.' if dla.size % 250 == 0
	end

	dla.save("canvas_60in-40in-5mm_#{'%03d' % n}")
	
	puts
end
