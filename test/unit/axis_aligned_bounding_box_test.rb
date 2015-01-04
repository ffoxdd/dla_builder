require_relative "../test_helper.rb"
require_relative "../../app/axis_aligned_bounding_box.rb"
require_relative "../../app/point.rb"

describe AxisAlignedBoundingBox do

  describe "#==" do
    it "returns true if the boxes have equal ranges" do
      AxisAlignedBoundingBox.new(1..2, 3..4).must_equal AxisAlignedBoundingBox.new(1..2, 3..4)
      AxisAlignedBoundingBox.new(1..2, 3..4).wont_equal AxisAlignedBoundingBox.new(5..6, 7..8)
    end
  end

  it "returns self" do
    box = AxisAlignedBoundingBox.new(1..2, 3..4)
    box.axis_aligned.must_equal box
  end

  describe "#intersects?" do
    let(:box) { AxisAlignedBoundingBox.new(0..3, 0..3) }

    it "returns true if one box completely contains the other" do
      other_box = AxisAlignedBoundingBox.new(1..2, 1..2)
      box.intersects?(other_box).must_equal true
    end

    it "returns true if the boxes partially intersect" do
      other_box = AxisAlignedBoundingBox.new(2..4, 2..4)
      box.intersects?(other_box).must_equal true
    end

    it "returns false if the x-ranges don't intersect" do
      other_box = AxisAlignedBoundingBox.new(4..5, 1..2)
      box.intersects?(other_box).must_equal false
    end

    it "returns false if the y-ranges don't intersect" do
      other_box = AxisAlignedBoundingBox.new(1..2, -2..-1)
      box.intersects?(other_box).must_equal false
    end

    it "returns true for closed intervals that intersect on an edge" do
      other_box = AxisAlignedBoundingBox.new(3..4, 0..3)
      box.intersects?(other_box).must_equal true
    end

    it "returns false for open intervals that intersect on the open edge" do
      other_box = AxisAlignedBoundingBox.new(-1...0, 0..3)
      box.intersects?(other_box).must_equal false
    end
  end

  describe "#covers?" do
    let(:box) { AxisAlignedBoundingBox.new(2..4, 2...4) }

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

  describe "#fits_within?" do
    let(:box) { AxisAlignedBoundingBox.new(2..4, 2...4) }

    it "returns true when it fits within the other box" do
      other_box = AxisAlignedBoundingBox.new(1..5, 1..5)
      box.fits_within?(other_box).must_equal true
    end

    it "returns false when the x range is too large" do
      other_box = AxisAlignedBoundingBox.new(2..3, 1..5)
      box.fits_within?(other_box).must_equal false
    end

    it "returns false when the y range is too large" do
      other_box = AxisAlignedBoundingBox.new(1..5, 2..3)
      box.fits_within?(other_box).must_equal false
    end
  end

  describe "#quadtrant" do
    let(:box) { AxisAlignedBoundingBox.new(0..4, -2...2) }

    it "returns four equal quadtrants" do
      box.quadtrant(0, 0).x_range.must_equal 0...2
      box.quadtrant(0, 0).y_range.must_equal -2...0

      box.quadtrant(1, 0).x_range.must_equal 2..4
      box.quadtrant(1, 0).y_range.must_equal -2...0

      box.quadtrant(0, 1).x_range.must_equal 0...2
      box.quadtrant(0, 1).y_range.must_equal 0...2

      box.quadtrant(1, 1).x_range.must_equal 2..4
      box.quadtrant(1, 1).y_range.must_equal 0...2
    end
  end

  describe "#perimeter" do
    it "returns the perimeter" do
      AxisAlignedBoundingBox.new(0..2, 0..3).perimeter.must_equal 10
    end

    it "works with a single-point bounding box" do
      AxisAlignedBoundingBox.new(1..1, 1..1).perimeter.must_equal 0
    end

    it "works with a degenerate bounding box" do
      AxisAlignedBoundingBox.new(1..2, 1..2).perimeter.must_equal 4
    end
  end

  describe "#offset" do
    it "returns the displacement from the lower-left corner to the origin" do
      AxisAlignedBoundingBox.new(-3..-1, 4..5).offset.must_equal Vector2D[-3, 4]
    end
  end

  describe "#at_origin" do
    it "returns a copy of the bounding box, translated to the origin" do
      bounding_box = AxisAlignedBoundingBox.new(-3..-1, 4..5)
      bounding_box.at_origin.must_equal AxisAlignedBoundingBox.new(0..2, 0..1)
    end
  end

  describe "#+" do
    it "returns a translated bounding box" do
      bounding_box = AxisAlignedBoundingBox.new(-3..-1, 4..5)
      (bounding_box + Vector2D[2, 2]).must_equal AxisAlignedBoundingBox.new(-1..1, 6..7)
    end
  end

  describe "#-" do
    it "returns a translated bounding box" do
      bounding_box = AxisAlignedBoundingBox.new(-3..-1, 4..5)
      (bounding_box - Vector2D[2, 2]).must_equal AxisAlignedBoundingBox.new(-5..-3, 2..3)
    end
  end

  describe "#vertices" do
    it "returns the vertices of the box" do
      bounding_box = AxisAlignedBoundingBox.new(-3..-1, 4..5)

      bounding_box.vertices.must_cyclically_equal([
        Point[-3, 4], Point[-3, 5], Point[-1, 5], Point[-1, 4]
      ])
    end

    it "works with a degenerate bounding box" do
      bounding_box = AxisAlignedBoundingBox.new(1..1, 1..1)
      bounding_box.vertices.must_equal([Point[1, 1], Point[1, 1], Point[1, 1], Point[1, 1]])
    end
  end

  describe "#center" do
    it "returns a vector for the center of the box" do
      bounding_box = AxisAlignedBoundingBox.new(0..2, 4..6)
      bounding_box.center.must_equal Vector2D[1, 5]
    end
  end

end
