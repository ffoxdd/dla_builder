require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/quadtree.rb"
# require_relative "../../sketchbook/lib/particle.rb" # TODO: remove the dependency on particle.rb

describe Quadtree do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { Quadtree.new(0...1, 0...1) }.must_be_silent
    end

    it "starts of with zero particles" do
      quadtree = Quadtree.new(0...1, 0...1)
      quadtree.size.must_equal 0      
    end
  end

  describe "#add" do
    let(:quadtree) { Quadtree.new(0...1, 0...1) }
    let(:particle) { Object.new }

    it "adds the particle" do
      quadtree.add(particle)
      quadtree.size.must_equal 1
    end
  end

  describe "#contains?" do
    let(:quadtree) { Quadtree.new(0...1, 0...1) }

    it "returns true if the quadtree contains the particle" do
      quadtree.contains?(mock_particle(0, 0)).must_equal true
      quadtree.contains?(mock_particle(0.5, 0.5)).must_equal true
      quadtree.contains?(mock_particle(0.999, 0.999)).must_equal true

      quadtree.contains?(mock_particle(1, 0)).must_equal false
      quadtree.contains?(mock_particle(0, 1)).must_equal false
      quadtree.contains?(mock_particle(0.5, 2)).must_equal false
      quadtree.contains?(mock_particle(2, 0.5)).must_equal false
      quadtree.contains?(mock_particle(10, 10)).must_equal false
    end
  end

  private

  require 'ostruct'

  def mock_particle(x = 1, y = 1)
    OpenStruct.new(:x => x, :y => y)
  end

end
