require_relative "../test_helper.rb"
require_relative "../../lib/range_intersection_calculator.rb"

describe RangeIntersectionCalculator do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { RangeIntersectionCalculator.new(0..1, 0..1) }.must_be_silent
    end
  end

  describe "intersect?" do
    it "returns true if the ranges overlap for a segment" do
      RangeIntersectionCalculator.new(0..4, 2..3).intersect?.must_equal true
      RangeIntersectionCalculator.new(2..3, 0..4).intersect?.must_equal true
    end

    it "returns true if one range contains the other" do
      RangeIntersectionCalculator.new(0..4, 2..6).intersect?.must_equal true
      RangeIntersectionCalculator.new(2..6, 0..4).intersect?.must_equal true
    end

    it "returns false if the ranges don't overlap" do
      RangeIntersectionCalculator.new(0..1, 2..3).intersect?.must_equal false
      RangeIntersectionCalculator.new(2..3, 0..1).intersect?.must_equal false
    end

    it "returns true if the ranges share an endpoint" do
      RangeIntersectionCalculator.new(0..1, 1..2).intersect?.must_equal true
      RangeIntersectionCalculator.new(1..2, 0..1).intersect?.must_equal true
    end

    it "returns false if the ranges share an enpoint, but one is open-ended" do
      RangeIntersectionCalculator.new(0...1, 1..2).intersect?.must_equal false
      RangeIntersectionCalculator.new(1..2, 0...1).intersect?.must_equal false
    end
  end

end
