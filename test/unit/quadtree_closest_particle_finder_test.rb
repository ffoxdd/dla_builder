require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/particle.rb"
require_relative "../../sketchbook/lib/quadtree.rb"
require_relative "../../sketchbook/lib/quadtree_closest_particle_finder.rb"

describe QuadtreeClosestParticleFinder do

  describe "#closest_particle" do
    let(:closer_particle) { Particle.new(1, 1, 1) }
    let(:further_particle) { Particle.new(10, 10, 1) }
    let(:particles) { Quadtree.new(-100..100, -100..100) }
    before { [closer_particle, further_particle].each { |particle| particles << particle } }

    it "returns the closest particle" do
      test_particle = Particle.new(2, 2, 1)
      finder = QuadtreeClosestParticleFinder.new(particles, test_particle, 1)
      finder.closest_particle.must_equal(closer_particle)
    end
  end

end
