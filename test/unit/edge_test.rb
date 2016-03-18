require_relative "../test_helper.rb"
require_relative "../../app/edge.rb"

describe Edge do

  describe "#relative_position/#point_to_the_left?" do
    let(:e0) { Vector2D[0, 0] }
    let(:e1) { Vector2D[0, 3] }
    let(:edge) { Edge.new(e0, e1) }

    it "returns 1 if point is to the left of the edge" do
      p = Vector2D[-1, 0]
      edge.relative_position(p).must_equal 1
      edge.point_to_the_left?(p).must_equal true
    end

    it "returns -1 if point is to the right of the edge" do
      p = Vector2D[5, 0]
      edge.relative_position(p).must_equal -1
      edge.point_to_the_left?(p).must_equal false
    end

    it "returns 0 if the point is on the line" do
      p = Vector2D[0, 1]
      edge.relative_position(p).must_equal 0
      edge.point_to_the_left?(p).must_equal false
    end
  end

  describe "#angle_to" do
    let(:edge) { Edge.new(Vector2D[0, 0], Vector2D[0, 1]) }

    it "calculates the angle to a vector" do
      edge.angle_to(Vector2D[1, 0]).must_be_close_to Math::PI / 2, 1e-6
    end

    it "calculates the angle to a edge" do
      other_edge = Edge.new(Vector2D[0, 0], Vector2D[0, -1])
      edge.angle_to(other_edge).must_be_close_to Math::PI, 1e-6
    end
  end

  describe "#length" do
    it "returns the length of the edge" do
      edge = Edge.new(Vector2D[-1, -1], Vector2D[2, 3])
      edge.length.must_equal 5
    end
  end

  describe "#right_handed?" do
    let(:edge) { Edge.new(Vector2D[0, 0], Vector2D[1, 0]) }

    it "returns true for a right-handed vector" do
      edge.right_handed?(Vector2D[0, 1]).must_equal true
    end

    it "returns false for a left-handed vector" do
      edge.right_handed?(Vector2D[0, -1]).must_equal false
    end

    it "can calculate handedness for an edge" do
      other_edge = Edge.new(Vector2D[0, 0], Vector2D[0 ,1])
      edge.right_handed?(other_edge).must_equal true
    end
  end

end
