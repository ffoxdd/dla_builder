require_relative "../test_helper.rb"

shared_examples_for "A Point" do

  describe "value methods (#x, #y)" do
    it "returns initialized values" do
      point = factory.call(1, 2)

      point.x.must_equal 1
      point.y.must_equal 2
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

end
