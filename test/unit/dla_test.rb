require_relative "../test_helper.rb"
require_relative "../../app/dla.rb"
require_relative "../../app/linear_particle_collection.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }
  let(:grower_source) { MiniTest::Mock.new }

  let(:seed) { test_particle }
  let(:seeds) { [seed] }
  let(:particles) { LinearParticleCollection.new }

  let(:options) do
    { 
      grower_source: grower_source, 
      seeds: seeds,
      particles: particles,

      radius: 2.0,
      overlap: 0.5,

      live: false
    } 
  end
  
  describe "#initialize" do
    it "succeeds when collaborators are passed in" do
      ->{ Dla.new(options) }.must_be_silent
    end

    it "succeeds without default collaborators" do
      ->{ Dla.new(live: false) }.must_be_silent
    end
  end

  describe "#size" do
    it "returns the number of seeds when no new particles have been added" do
      dla = Dla.new(seeds: seeds)
      dla.size.must_equal 1
    end
  end

  describe "#grow" do
    let(:new_particle) { test_particle }
    let(:dla) { Dla.new(options) }

    it "calls through to the grower and renders a new particle onto the aggregate" do
      grower_source.expect(:new, grower, [particles, 2.0, 0.5, Point.new(0.5, 0.5)])
      grower.expect(:grow, new_particle)

      dla.grow

      grower.verify
      dla.size.must_equal 2
    end
  end

  describe "#save" do
    let(:persister) { MiniTest::Mock.new }
    let(:dla) { Dla.new(persister: persister) }

    it "persists by calling through to the persister" do
      persister.expect(:save, nil, [dla, "filename"])
      dla.save("filename")
      persister.verify
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
    let(:seed) { test_particle }

    it "visits seeds" do
      dla = Dla.new(seeds: seed, live: false) { |particle| visitor.visit(particle) }
      visitor.expect(:visit, nil, [seed])

      dla.accept
      visitor.verify
    end

    it "visits new particles" do
      visited_particles = []
      dla = Dla.new(seeds: seed, live: false) { |particle| visited_particles << particle }

      2.times { dla.grow }
      dla.accept

      visited_particles.size.must_equal 3
    end

    it "visits as particles are added with the live options" do
      visited_particles = []
      dla = Dla.new(seeds: seed, live: true) { |particle| visited_particles << particle }
      visited_particles.size.must_equal 1

      dla.grow
      visited_particles.size.must_equal 2
    end
  end

  private

  def test_particle(x = 0, y = 0, r = 0.5)
    Particle.new(x, y, r)
  end

end
