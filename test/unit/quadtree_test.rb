require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/quadtree.rb"

describe Quadtree do

  describe "#initialize" do
    it "initializes with valid arguments" do
      -> { Quadtree.new(0...1, 0...1) }.must_be_silent
    end

    it "requires open-ended range arguments" do
      -> { Quadtree.new(0, 0) }.must_raise(ArgumentError)
      -> { Quadtree.new(0..1, 0..1) }.must_raise(ArgumentError)
    end

    it "starts of with zero particles" do
      quadtree = Quadtree.new(0...1, 0...1)
      quadtree.size.must_equal 0      
    end
  end

  describe "#add" do
    let(:quadtree) { Quadtree.new(0...1, 0...1) }

    it "adds a particle" do
      quadtree.add(mock_particle(0.5, 0.5))
      quadtree.size.must_equal 1
    end

    it "doesn't add a particle if it is outside the tree's bounds" do
      quadtree.add(mock_particle(2, 2))
      quadtree.size.must_equal 0
    end
  end

  describe "#covers?" do
    let(:quadtree) { Quadtree.new(0...1, 0...1) }

    it "returns true if the quadtree covers the particle" do
      quadtree.covers?(mock_particle(0, 0)).must_equal true
      quadtree.covers?(mock_particle(0.5, 0.5)).must_equal true
      quadtree.covers?(mock_particle(0.999, 0.999)).must_equal true

      quadtree.covers?(mock_particle(1, 0)).must_equal false
      quadtree.covers?(mock_particle(0, 1)).must_equal false
      quadtree.covers?(mock_particle(0.5, 2)).must_equal false
      quadtree.covers?(mock_particle(2, 0.5)).must_equal false
      quadtree.covers?(mock_particle(10, 10)).must_equal false
    end
  end

  private

  require 'ostruct'

  def mock_particle(x = 1, y = 1)
    OpenStruct.new(:x => x, :y => y)
  end

end
