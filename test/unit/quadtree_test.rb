require_relative "../test_helper.rb"
require_relative "../../app/quadtree.rb"
require_relative "../../app/axis_aligned_bounding_box.rb"

require 'set'

describe Quadtree do

  describe "#initialize" do
    it "starts off with zero particles" do
      quadtree = Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1))
      quadtree.size.must_equal 0
    end

    it "start off with zero depth" do
      quadtree = Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1))
      quadtree.depth.must_equal 0
    end
  end

  describe "#<<" do
    let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1), max_depth: 3) }

    it "adds a particle" do
      quadtree << mock_particle(0.5, 0.5)
      quadtree.size.must_equal 1
    end

    it "doesn't add a particle if it is outside the tree's bounds" do
      quadtree << mock_particle(2, 2)
      quadtree.size.must_equal 0
    end

    it "subdivides to the maximum depth upon adding the first particle" do
      quadtree << mock_particle(0.5, 0.5)
      quadtree.depth.must_equal 3
    end
  end

  describe "#covers?" do
    let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1)) }

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

  describe "Enumerable" do
    let(:particles) { 4.times.map { mock_particle } }
    let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...10, 0...10)) }
    before { particles.each { |particle| quadtree << particle } }

    it "visits all the particles" do
      Set.new(quadtree.to_a).must_equal Set.new(particles)
    end
  end

  private

  require 'ostruct'

  def mock_particle(x = 1, y = 1)
    OpenStruct.new(x: x, y: y)
  end

end
