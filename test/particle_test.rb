require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../lib/particle.rb"

describe Particle do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { Particle.new(0, 0, 1) }.must_be_silent
    end
  end

  describe "value methods (#x, #y, #radius)" do
    it "returns initialized values" do
      particle = Particle.new(1, 2, 3)

      particle.x.must_equal 1
      particle.y.must_equal 2
      particle.radius.must_equal 3
    end
  end

  describe "#magnitude" do
    it "returns zero if the particle is at the origin" do
      particle = Particle.new(0, 0, 1)
      particle.magnitude.must_equal 0
    end

    it "returns the distance from the origin for a particle in quadrant I" do
      particle = Particle.new(1, 1, 1)
      particle.magnitude.must_equal Math.sqrt(2)
    end

    it "returns the distance from the origin for a particle in quadrant III" do
      particle = Particle.new(-2, -3, 1)
      particle.magnitude.must_equal Math.sqrt(13)
    end
  end

  describe "#extent" do
    it "returns the radius if the particle is at the origin" do
      particle = Particle.new(0, 0, 2.5)
      particle.extent.must_equal 2.5
    end

    it "returns the magnitude plus the radius" do
      particle = Particle.new(3, 4, 5)
      particle.extent.must_equal 10
    end
  end

  describe "#distance" do
    let(:particle) { Particle.new(0, 0, 1) }

    it "returns the distance between the particles' centers, minus their radii" do
      other_particle = Particle.new(2, 0, 0.5)
      particle.distance(other_particle).must_equal(0.5)
    end

    it "returns a negative number if the particles overlap" do
      other_particle = Particle.new(0, 1, 0.5)
      particle.distance(other_particle).must_equal(-0.5)
    end

    it "returns zero if they just touch" do
      other_particle = Particle.new(2, 0, 1)
      particle.distance(other_particle).must_equal(0)
    end
  end

  describe "#step" do
    it "steps the particle the given distance in a random direction" do
      particle = Particle.new(0, 0, 1)
      particle.step(3)

      particle.magnitude.must_be_close_to 3, 0.0001
    end

    it "doesn't step the particle the same way each time" do
      particle = Particle.new(0, 0, 1)
      other_particle = Particle.new(0, 0, 1)

      particle.step(2)
      other_particle.step(2)

      particle.x.wont_equal other_particle.x
      particle.y.wont_equal other_particle.y
    end
  end

end

