require_relative "../test_helper"
require_relative "../../app/bounding_box"
require_relative "../../app/vector2d"

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
      point = Vector2D[3, 3]
      box.covers?(point).must_equal true
    end

    it "returns false if the x coordinate is out of range" do
      point = Vector2D[5, 3]
      box.covers?(point).must_equal false
    end

    it "returns false if the y coordinate is out of range" do
      point = Vector2D[3, 5]
      box.covers?(point).must_equal false
    end

    it "returns true if it borders on a closed interval" do
      point = Vector2D[4, 3]
      box.covers?(point).must_equal true
    end

    it "returns false if it borders on an open interval" do
      point = Vector2D[3, 4]
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

  describe ".from_vertices" do
    it "builds a bounding box from the locations of its four corners" do
      points = [Vector2D[1, 1], Vector2D[0, 0], Vector2D[-1, 1], Vector2D[0, 2]]
      bounding_box = BoundingBox.from_vertices(points)

      vertices = bounding_box.vertices

      # TODO: clean up with a within_delta matcher for bounding_boxes
      vertices[0].distance(points[0]).must_be_close_to 0, 1e-10
      vertices[1].distance(points[1]).must_be_close_to 0, 1e-10
      vertices[2].distance(points[2]).must_be_close_to 0, 1e-10
      vertices[3].distance(points[3]).must_be_close_to 0, 1e-10
    end

    it "works with vertices indicated in the opposite direction" do
      points = [Vector2D[0, 2], Vector2D[-1, 1], Vector2D[0, 0], Vector2D[1, 1]]
      bounding_box = BoundingBox.from_vertices(points)

      vertices = bounding_box.vertices
      # TODO: implement with a within_delta matcher for bounding boxes
    end

    it "works in the case, lol" do
      points = [Vector2D[-1.0, 1.0], Vector2D[1.0, 1.0], Vector2D[1.0, 0.0], Vector2D[-1.0, -0.0]]
      bounding_box = BoundingBox.from_vertices(points)

      vertices = bounding_box.vertices
      # TODO: implement with a within_delta matcher for bounding boxes
    end
  end

  # describe "vertices" do
  #   it "returns the four corners of the box" do
  #     pi, rt2 = Math::PI, Math.sqrt(2)
  #     box = BoundingBox.new(0..1, 0..1, rotation: pi/4)
  #
  #     box.vertices.must_cyclically_equal [
  #       Vector2D[0, 0], Vector2D[-rt2/2, -rt2/2], Vector2D[0, rt2], Vector2D[rt2/2, rt2/2]
  #     ]
  #   end
  # end

end
