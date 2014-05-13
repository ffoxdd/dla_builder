require_relative "../test_helper.rb"
require_relative "../../app/particle.rb"
require_relative "./shared_examples_for_points.rb"

describe Particle do

  it_behaves_like "A Point" do
    let(:factory) { ->(x, y) { Particle.new(x: x, y: y, radius: 1) } }
  end

  describe "initialization" do
    it "provides sensible defaults" do
      particle = Particle.new

      particle.x.must_equal 0
      particle.y.must_equal 0
      particle.radius.must_equal 1
    end

    it "respects initial x and y values" do
      particle = Particle.new(x: 1, y: 2)

      particle.x.must_equal 1
      particle.y.must_equal 2
    end

    it "respects an initial center value" do
      particle = Particle.new(center: Point[3, 4])

      particle.x.must_equal 3
      particle.y.must_equal 4
    end
  end

  describe "value methods (#x, #y, #radius)" do
    it "returns initialized values" do
      particle = Particle.new(x: 1, y: 2, radius: 3)

      particle.x.must_equal 1
      particle.y.must_equal 2
      particle.radius.must_equal 3
    end
  end

  describe "#magnitude" do
    it "returns zero if the particle is at the origin" do
      particle = Particle.new
      particle.magnitude.must_equal 0
    end

    it "returns the distance from the origin for a particle in quadrant I" do
      particle = Particle.new(x: 1, y: 1, radius: 1)
      particle.magnitude.must_be_close_to Math.sqrt(2), 0.00001
    end

    it "returns the distance from the origin for a particle in quadrant III" do
      particle = Particle.new(x: -2, y: -3, radius: 1)
      particle.magnitude.must_be_close_to Math.sqrt(13), 0.00001
    end
  end

  describe "#distance" do
    let(:particle) { Particle.new(x: 0, y: 0, radius: 1) }

    it "returns the distance between the particles' centers, minus their radii" do
      other_particle = Particle.new(x: 2, y: 0, radius: 0.5)
      particle.distance(other_particle).must_equal(0.5)
    end

    it "returns a negative number if the particles overlap" do
      other_particle = Particle.new(x: 0, y: 1, radius: 0.5)
      particle.distance(other_particle).must_equal(-0.5)
    end

    it "returns zero if they just touch" do
      other_particle = Particle.new(x: 2, y: 0, radius: 1)
      particle.distance(other_particle).must_equal(0)
    end
  end

  describe "#step" do
    it "steps the particle the given distance in a random direction" do
      particle = Particle.new
      particle = particle.step(3)

      particle.magnitude.must_be_close_to 3, 0.0001
    end

    it "doesn't step the particle the same way each time" do
      particle = Particle.new
      other_particle = Particle.new

      particle = particle.step(2)
      other_particle = other_particle.step(2)

      particle.x.wont_equal other_particle.x
      particle.y.wont_equal other_particle.y
    end
  end

  describe "#extent" do
    it "returns a particle with the absolute value of both dimensions" do
      Particle.new(x: -3, y: -2, radius: 0.5).extent.must_equal Point[3.5, 2.5]
    end
  end

  describe "#within_radius?" do
    it "returns true if the particle is within the radius" do
      Particle.new(x: 2.5, y: 3.5, radius: 0.5).within_radius?(5.01).must_equal true
    end

    it "returns false if the particle is not within the radius" do
      Particle.new(x: 2.5, y: 3.5, radius: 0.5).within_radius?(5).must_equal false
    end
  end

  describe "#children" do
    it "initializes with no children" do
      Particle.new(x: 1, y: 1, radius: 0.5).children.empty?.must_equal true
    end

    it "can add a child" do
      particle_1 = Particle.new(x: 1, y: 1, radius: 0.5)
      particle_2 = Particle.new(x: 1, y: 1, radius: 0.5)

      particle_1.add_child(particle_2)
      particle_1.children.must_equal [particle_2]
    end
  end

  describe "#depth" do
    it "returns zero for a leaf" do
      Particle.new.depth.must_equal 0
    end

    it "returns the depth for a non-leaf" do
      particle = Particle.new
      particle.add_child(Particle.new)

      particle.depth.must_equal 1
    end
  end

end
