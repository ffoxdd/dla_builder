require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/quadtree_particle_collection.rb"
require_relative "../../sketchbook/lib/particle.rb"

describe QuadtreeParticleCollection do

  let(:collection) { QuadtreeParticleCollection.new }

  describe "#initialize" do
    it "does not blow up" do
      -> { QuadtreeParticleCollection.new }.must_be_silent
    end

    it "starts of with zero particles" do
      collection.size.must_equal 0
    end
  end

  describe "#<<" do
    it "adds particles to the collection" do
      collection << Particle.new(0, 0, 1)
      collection.size.must_equal 1
    end
  end

  describe "Enumerable" do
    let(:particles) { 4.times.map { Particle.new(0, 0, 1) } }
    before { particles.each { |particle| collection << particle } }

    it "visits all the particles" do
      Set.new(collection.to_a).must_equal Set.new(particles)
    end
  end

  describe "#closest_particle" do
    let(:closer_particle) { Particle.new(1, 1, 1) }
    let(:further_particle) { Particle.new(10, 10, 1) }
    before { [closer_particle, further_particle].each { |particle| collection << particle } }

    it "returns the closest particle" do
      test_particle = Particle.new(2, 2, 1)
      collection.closest_particle(test_particle).must_equal closer_particle
    end
  end

end
