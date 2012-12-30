require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../lib/particle.rb"

describe Particle do

  describe "#initialize" do
    it "doesn't blow up" do
      Particle.new(0, 0, 1)
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

end

