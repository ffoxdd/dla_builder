require_relative "../test_helper.rb"
require_relative "../../app/grower.rb"

describe Grower do

	let(:particles) { MiniTest::Mock.new }
	let(:closest_particle) { MiniTest::Mock.new }
	let(:new_particle) { MiniTest::Mock.new }
  let(:grower) { Grower.new(particles, 1.0, 0.2, 4.0) }

	let(:particle_new_stub) do
		lambda do |x, y, radius|
			x.must_equal 0
			y.must_equal 0
			radius.must_equal 1.0
			new_particle
		end
	end

	describe "#grow" do
		it "spawns a new particle and steps it around until stuck" do
			Particle.stub(:new, particle_new_stub) do
				new_particle.expect(:step, new_particle, [10.0]) # extent + (radius * 6)
				particles.expect(:closest_particle, closest_particle, [new_particle])
				new_particle.expect(:distance, -1.0, [closest_particle])

				grower.grow

	      new_particle.verify
	      particles.verify
	    end
		end
	end

end
