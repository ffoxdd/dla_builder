require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/face"
require_relative "../../../app/point"
require_relative "../../../app/dcel/face"
require_relative "../../../app/ray"

describe Triangulation::Face do

  def from_points(points)
    lines = DCEL.cyclical_each_pair(points).map do |previous_point, next_point|
      Ray.from_endpoints(previous_point, next_point)
    end

    Triangulation::Face.new(lines)
  end

  describe "#points" do
    let(:points) { [Point[0, 0], Point[10, 0], Point[0, 10]] }
    let(:face) { from_points(points) }

    it "returns the points for the face" do
      face.points.must_equal(points)
    end
  end

  describe "#contains?" do
    let(:points) { [Point[0, 0], Point[10, 0], Point[0, 10]] }
    let(:face) { from_points(points) }

    it "returns true for a point in the interior of the face" do
      point = Point[2, 2]
      face.contains?(point).must_equal(true)
    end

    it "returns false for a point outside of the face" do
      point = Point[100, 100]
      face.contains?(point).must_equal(false)
    end
  end

  describe "#bounded?" do
    let(:right_handed_points) { [Point[0, 0], Point[1, 0], Point[0, 1]] }

    it "is true for a face with right-handed orientation" do
      face = from_points(right_handed_points)
      face.bounded?.must_equal(true)
    end

    it "is false for a face with left-handed orientation" do
      face = from_points(right_handed_points.reverse)
      face.bounded?.must_equal(false)
    end
  end

end
