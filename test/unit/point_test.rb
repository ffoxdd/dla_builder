require_relative "../test_helper.rb"
require_relative "../../app/point.rb"
require_relative "./shared_examples_for_points.rb"

describe Point do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { Point.new(0, 0) }.must_be_silent
    end
  end

  it_behaves_like "A Point" do
    let(:factory) { Point.method(:new) }
  end

  describe "+" do
    it "adds two points together" do
      point_1 = Point.new(1, 1)
      point_2 = Point.new(3, 4)

      result = point_1 + point_2
      
      result.x.must_equal 4
      result.y.must_equal 5
    end
  end

  describe "equality" do
    it "returns true for points with equal values" do
      point = Point.new(0, 0)
      same_point = Point.new(0, 0)
      different_point = Point.new(1, 1)

      (point == same_point).must_equal true
      (point == different_point).must_equal false

      (point != same_point).must_equal false
      (point != different_point).must_equal true
    end
  end

  describe "#distance" do
    it "returns the distance between the two points" do
      point_1 = Point.new(0, 0)
      point_2 = Point.new(3, 4)

      point_1.distance(point_2).must_equal 5.0
    end
  end

  describe ".random" do
    it "builds a point with the specified magnitude in a random direction" do
      Point.random(3).magnitude.must_be_close_to 3, 0.00001
    end

    it "doesn't generate the same point each time" do
      point_1 = Point.random(4)
      point_2 = Point.random(4)

      (point_1 == point_2).must_equal false
    end
  end

  describe "#extent" do
    it "returns a point with the absolute value of both dimensions" do
      Point.new(-3, -2).extent.must_equal Point.new(3, 2)
    end
  end

end
