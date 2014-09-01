require_relative "../test_helper.rb"
require_relative "../../app/particle.rb"
require_relative "../../app/quadtree.rb"
require_relative "../../app/quadtree_closest_particle_finder.rb"

describe QuadtreeClosestParticleFinder do

  describe "#closest_particle" do
    let(:closer_particle) { Particle.new(x: 1, y: 1, radius: 1) }
    let(:further_particle) { Particle.new(x: 10, y: 10, radius: 1) }
    let(:particles) { Quadtree.new(AxisAlignedBoundingBox.new(-100..100, -100..100)) }
    before { [closer_particle, further_particle].each { |particle| particles << particle } }

    it "returns the closest particle" do
      test_particle = Particle.new(x: 2, y: 2, radius: 1)
      finder = QuadtreeClosestParticleFinder.new(particles, test_particle, 1)
      finder.closest_particle.must_equal(closer_particle)
    end
  end

end
