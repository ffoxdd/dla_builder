require_relative "../test_helper.rb"
require_relative "../../app/particle_collection.rb"
require_relative "../../app/particle.rb"
require "set"

describe ParticleCollection do

  let(:collection) { ParticleCollection.new(1) }

  describe "#initialize" do
    it "starts of with zero particles" do
      collection.size.must_equal 0
    end
  end

  describe "#<<" do
    it "adds particles to the collection" do
      collection << Particle.new
      collection.size.must_equal 1
    end
  end

  describe "Enumerable" do
    let(:particles) { 4.times.map { Particle.new } }
    before { particles.each { |particle| collection << particle } }

    it "visits all the particles" do
      Set.new(collection.to_a).must_equal Set.new(particles)
    end
  end

  describe "#closest_particle" do
    let(:closer_particle) { Particle.new(x: 1, y: 1, radius: 1) }
    let(:further_particle) { Particle.new(x: 10, y: 10, radius: 1) }
    before { [closer_particle, further_particle].each { |particle| collection << particle } }

    it "returns the closest particle" do
      test_particle = Particle.new(x: 2, y: 2, radius: 1)
      collection.closest_particle(test_particle).must_equal closer_particle
    end
  end

end
