require_relative "../test_helper.rb"

shared_examples_for "A Point" do

  describe "value methods (#x, #y)" do
    it "returns initialized values" do
      point = factory.call(1, 2)

      point.x.must_equal 1
      point.y.must_equal 2
    end
  end

  describe "+" do
    it "adds two points together" do
      point_1 = factory.call(1, 1)
      point_2 = factory.call(3, 4)

      result = point_1 + point_2
      
      result.x.must_equal 4
      result.y.must_equal 5
    end
  end

  describe "equality" do
    it "returns true for points with equal values" do
      point = factory.call(0, 0)
      same_point = factory.call(0, 0)
      different_point = factory.call(1, 1)

      (point == same_point).must_equal true
      (point == different_point).must_equal false

      (point != same_point).must_equal false
      (point != different_point).must_equal true
    end
  end

  describe "#magnitude" do
    it "returns zero if the point is at the origin" do
      point = factory.call(0, 0)
      point.magnitude.must_equal 0
    end

    it "returns the distance from the origin for a point in quadrant I" do
      point = factory.call(1, 1)
      point.magnitude.must_equal Math.sqrt(2)
    end

    it "returns the distance from the origin for a point in quadrant III" do
      point = factory.call(-2, -3)
      point.magnitude.must_equal Math.sqrt(13)
    end
  end

  describe "#distance" do
    it "returns the distance between the two points" do
      point_1 = factory.call(0, 0)
      point_2 = factory.call(3, 4)

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
	
end
