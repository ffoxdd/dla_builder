require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../app/bounding_box.rb"

describe BoundingBox do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { BoundingBox.new(0..1, 0..1) }.must_be_silent
    end
  end

  describe "#intersects?" do
    let(:box) { BoundingBox.new(0..3, 0..3) }

    it "returns true if one box completely contains the other" do
      other_box = BoundingBox.new(1..2, 1..2)
      box.intersects?(other_box).must_equal true
    end

    it "returns true if the boxes partially intersect" do
      other_box = BoundingBox.new(2..4, 2..4)
      box.intersects?(other_box).must_equal true
    end

    it "returns false if the x-ranges don't intersect" do
      other_box = BoundingBox.new(4..5, 1..2)
      box.intersects?(other_box).must_equal false
    end

    it "returns false if the y-ranges don't intersect" do
      other_box = BoundingBox.new(1..2, -2..-1)
      box.intersects?(other_box).must_equal false
    end

    it "returns true for closed intervals that intersect on an edge" do
      other_box = BoundingBox.new(3..4, 0..3)
      box.intersects?(other_box).must_equal true
    end

    it "returns false for open intervals that intersect on the open edge" do
      other_box = BoundingBox.new(-1...0, 0..3)
      box.intersects?(other_box).must_equal false
    end
  end

end
