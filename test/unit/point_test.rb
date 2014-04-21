require_relative "../test_helper.rb"
require_relative "../../app/point.rb"
require_relative "./shared_examples_for_points.rb"

describe Point do

  it_behaves_like "A Point" do
    let(:factory) { Point.method(:new) }
  end

  describe "+" do
    it "adds, element-wise" do
      point_1 = Point.new(1, 1)
      point_2 = Point.new(3, 4)

      result = point_1 + point_2
      
      result.x.must_equal 4
      result.y.must_equal 5
    end
  end

  describe "-" do
    it "subtracts, element-wise" do
      point_1 = Point.new(1, 1)
      point_2 = Point.new(3, 4)

      result = point_1 - point_2

      result.x.must_equal -2
      result.y.must_equal -3
    end
  end

  describe "[]" do
    it "allows indexing" do
      point = Point.new(2, 3)

      point[0].must_equal 2
      point[1].must_equal 3

      -> { point[2] }.must_raise(IndexError)
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

  describe "#max" do
    it "returns a point with the maximum of both points along each dimension" do
      point_1 = Point.new(1, 2)
      point_2 = Point.new(-3, 4)

      point_1.max(point_2).must_equal Point.new(1, 4)
    end
  end

end
