require_relative "../test_helper.rb"
require_relative "../../app/dla.rb"
require_relative "../../app/linear_particle_collection.rb"

describe Dla do

  describe "#size" do
    it "returns the number of seeds when no new particles have been added" do
      dla = Dla.new(seeds: Particle.new)
      dla.size.must_equal 1
    end
  end

  describe "#grow" do
    let(:grower) { Minitest::Mock.new }
    let(:particle) { Particle.new(0, 0, 1) }
    let(:dla) { Dla.new(seeds: particle, radius: 1, overlap: 0.1) }

    let(:grower_new_stub) do
      lambda do |particles, radius, overlap, extent|
        particles.each { |p| p.must_equal(particle) }
        radius.must_equal 1
        overlap.must_equal 0.1
        extent.must_equal Point.new(1, 1)
        grower
      end
    end

    it "calls through to the Grower" do
      Grower.stub(:new, grower_new_stub) do
        grower.expect(:grow, nil, [])
        dla.grow # TODO: stub that the yielded block is handled correctly
        grower.verify
      end
    end
  end

  describe "#save" do
    let(:persister) { Minitest::Mock.new }
    let(:dla) { Dla.new }

    let(:persister_new_stub) do
      lambda do |persisted_object, name|
        persisted_object.must_equal dla
        name.must_equal "filename"
        persister
      end
    end

    it "calls through to the Persister" do
      Persister.stub(:new, persister_new_stub) do
        persister.expect(:save, nil, [])
        dla.save("filename")
        persister.verify
      end
    end
  end

  describe "#within?" do
    let(:seeds) { [Particle.new(1, 0, 1), Particle.new(0, 1, 1)] }
    let(:dla) { Dla.new(seeds: seeds) }

    it "returns true when within the given bounds" do
      dla.within?(BoundingBox.new(-2..2, -2..2)).must_equal true
    end

    it "returns false when outside the given x range" do
      dla.within?(BoundingBox.new(-1..1, -2..2)).must_equal false
    end

    it "returns false when outside the given y range" do
      dla.within?(BoundingBox.new(-2..2, -1..1)).must_equal false
    end
  end

  describe "visitor pattern" do
    let(:visitor) { MiniTest::Mock.new }
    let(:seed) { Particle.new }

    it "visits seeds" do
      dla = Dla.new(seeds: seed, live: false)
      visitor.expect(:visit, nil, [seed])

      dla.accept { |particle| visitor.visit(particle) }
      visitor.verify
    end

    it "visits new particles" do
      visited_particles = []
      dla = Dla.new(seeds: seed, live: false) 

      2.times { dla.grow }
      dla.accept { |particle| visited_particles << particle }

      visited_particles.size.must_equal 3
    end

    it "visits as particles are added with the live option" do
      visited_particles = []
      dla = Dla.new(seeds: seed, live: true) { |particle| visited_particles << particle }
      visited_particles.size.must_equal 1

      dla.grow
      visited_particles.size.must_equal 2
    end
  end

end
