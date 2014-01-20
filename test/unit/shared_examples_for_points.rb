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
      point.magnitude.must_be_close_to Math.sqrt(2), 1e-6
    end

    it "returns the distance from the origin for a point in quadrant III" do
      point = factory.call(-2, -3)
      point.magnitude.must_be_close_to Math.sqrt(13), 1e-6
    end
  end

  describe "#rotate" do
    it "rotates the particle the specified radians" do
      point = factory.call(1, 0)
      rotated_point = point.rotate(Math::PI / 2)

      rotated_point.x.must_be_close_to 0, 1e-6
      rotated_point.y.must_be_close_to 1, 1e-6
    end
  end

end
