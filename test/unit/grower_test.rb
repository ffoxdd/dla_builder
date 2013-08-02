require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/grower.rb"

describe Grower do

	let(:particles) { MiniTest::Mock.new }
	let(:particle_source) { MiniTest::Mock.new }
	let(:closest_particle) { MiniTest::Mock.new }
	let(:new_particle) { MiniTest::Mock.new }

	let(:grower) do 
		Grower.new \
			:particles => particles, 
			:particle_source => particle_source, 
			:radius => 1.0, 
			:overlap => 0.2,
			:extent => 4.0
	end

	describe "#grow" do
		it "spawns a new particle and steps it around until stuck" do
			particle_source.expect(:new, new_particle, [0, 0, 1.0])
			new_particle.expect(:step, new_particle, [10.0]) # extent + (radius * 6)
			particles.expect(:closest_particle, closest_particle, [new_particle])
			new_particle.expect(:distance, -1.0, [closest_particle])

			grower.grow

      particle_source.verify
      new_particle.verify
      particles.verify
		end
	end

end
