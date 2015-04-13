require_relative "../test_helper.rb"
require_relative "../../app/bounding_box.rb"
require_relative "../../app/point.rb"

describe BoundingBox do

  describe "#==" do
    it "returns true if the boxes are the same" do
      box = BoundingBox.new(1..2, 3..4)

      box.must_equal BoundingBox.new(1..2, 3..4)
      box.must_equal BoundingBox.new(0..1, 2..3, translation: Vector2D[1, 1])

      box.wont_equal BoundingBox.new(5..6, 7..8)
      box.wont_equal BoundingBox.new(1..2, 3..4, rotation: Math::PI)
    end
  end

  describe "#axis_aligned" do
    it "returns the axis aligned bounding box" do
      box = BoundingBox.new(0..2, 0..4)
      aabb = AxisAlignedBoundingBox.new(0..2, 0..4)

      box.axis_aligned.must_equal aabb
    end
  end

  describe "#covers?" do
    let(:box) { BoundingBox.new(2..4, 2...4) }

    it "returns true if the point is within the x and y range" do
      point = Point[3, 3]
      box.covers?(point).must_equal true
    end

    it "returns false if the x coordinate is out of range" do
      point = Point[5, 3]
      box.covers?(point).must_equal false
    end

    it "returns false if the y coordinate is out of range" do
      point = Point[3, 5]
      box.covers?(point).must_equal false
    end

    it "returns true if it borders on a closed interval" do
      point = Point[4, 3]
      box.covers?(point).must_equal true
    end

    it "returns false if it borders on an open interval" do
      point = Point[3, 4]
      box.covers?(point).must_equal false
    end
  end

  describe "#perimeter" do
    it "returns the perimeter" do
      BoundingBox.new(0..2, 0..3).perimeter.must_equal 10
    end
  end

  describe "#fits_within?" do
    # TODO
  end

  # describe "vertices" do
  #   it "returns the four corners of the box" do
  #     pi, rt2 = Math::PI, Math.sqrt(2)
  #     box = BoundingBox.new(0..1, 0..1, rotation: pi/4)
  #
  #     box.vertices.must_cyclically_equal [
  #       Point[0, 0], Point[-rt2/2, -rt2/2], Point[0, rt2], Point[rt2/2, rt2/2]
  #     ]
  #   end
  # end

end
