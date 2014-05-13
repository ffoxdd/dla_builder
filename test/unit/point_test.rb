require_relative "../test_helper.rb"
require_relative "../../app/point.rb"
require_relative "./shared_examples_for_vectors.rb"
require_relative "./shared_examples_for_points.rb"

describe Point do

  it_behaves_like "A Vector" do
    let(:factory) { Point.method(:new) }
  end

  it_behaves_like "A Point" do
    let(:factory) { Point.method(:new) }
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

  describe "#left_of?" do
    it "returns true if the point is to the left of the edge" do
      edge = [Point.new(0, 0), Point.new(0, 1)]
      left_point = Point.new(-1, 0)
      center_point = Point.new(0, 0)
      right_point = Point.new(1, 0)

      left_point.left_of?(edge).must_equal true
      center_point.left_of?(edge).must_equal false
      right_point.left_of?(edge).must_equal false
    end
  end

end
