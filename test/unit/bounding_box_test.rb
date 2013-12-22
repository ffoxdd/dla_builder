require_relative "../test_helper.rb"
require_relative "../../app/bounding_box.rb"

describe BoundingBox do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { BoundingBox.new(0..1, 0..1) }.must_be_silent
    end
  end

  describe "#intersects?" do
    let(:box) { BoundingBox.new(0..3, 0..3) }

    it "returns true if one box completely contains the other" do
      other_box = BoundingBox.new(1..2, 1..2)
      box.intersects?(other_box).must_equal true
    end

    it "returns true if the boxes partially intersect" do
      other_box = BoundingBox.new(2..4, 2..4)
      box.intersects?(other_box).must_equal true
    end

    it "returns false if the x-ranges don't intersect" do
      other_box = BoundingBox.new(4..5, 1..2)
      box.intersects?(other_box).must_equal false
    end

    it "returns false if the y-ranges don't intersect" do
      other_box = BoundingBox.new(1..2, -2..-1)
      box.intersects?(other_box).must_equal false
    end

    it "returns true for closed intervals that intersect on an edge" do
      other_box = BoundingBox.new(3..4, 0..3)
      box.intersects?(other_box).must_equal true
    end

    it "returns false for open intervals that intersect on the open edge" do
      other_box = BoundingBox.new(-1...0, 0..3)
      box.intersects?(other_box).must_equal false
    end
  end

  describe "#covers?" do
    let(:box) { BoundingBox.new(2..4, 2...4) }

    it "returns true if the point is within the x and y range" do
      point = mock_point(3, 3)
      box.covers?(point).must_equal true
    end

    it "returns false if the x coordinate is out of range" do
      point = mock_point(5, 3)
      box.covers?(point).must_equal false
    end

    it "returns false if the y coordinate is out of range" do
      point = mock_point(3, 5)
      box.covers?(point).must_equal false
    end

    it "returns true if it borders on a closed interval" do
      point = mock_point(4, 3)
      box.covers?(point).must_equal true
    end

    it "returns false if it borders on an open interval" do
      point = mock_point(3, 4)
      box.covers?(point).must_equal false
    end
  end

  describe "#quadtrant" do
    let(:box) { BoundingBox.new(0..4, -2...2) }

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

  private

    def mock_point(x, y)
      OpenStruct.new(x: x, y: y)
    end

end
