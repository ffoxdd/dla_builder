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

end

