require_relative "../test_helper.rb"
require_relative "../../app/point.rb"
require_relative "./shared_examples_for_vectors.rb"
require_relative "./shared_examples_for_points.rb"

describe Point do

  it_behaves_like "A Vector" do
    let(:factory) { Point.method(:[]) }
  end

  it_behaves_like "A Point" do
    let(:factory) { Point.method(:[]) }
  end

  describe "#distance" do
    it "returns the distance between the two points" do
      point_1 = Point[0, 0]
      point_2 = Point[3, 4]

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
      Point[-3, -2].extent.must_equal Point[3, 2]
    end
  end

  describe "#max" do
    it "returns a point with the maximum of both points along each dimension" do
      point_1 = Point[1, 2]
      point_2 = Point[-3, 4]

      point_1.max(point_2).must_equal Point[1, 4]
    end
  end

  describe "#to_v" do
    it "returns the point's center as a vector" do
      Point[1, 2].to_v.must_equal Vector2D[1, 2]
    end
  end

end
