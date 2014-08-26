require_relative "../test_helper.rb"
require_relative "../../app/edge.rb"

describe Edge do

  describe "#relative_position/#point_to_the_left?" do
    let(:e0) { Point[0, 0] }
    let(:e1) { Point[0, 3] }
    let(:edge) { Edge.new(e0, e1) }

    it "returns 1 if point is to the left of the edge" do
      p = Point[-1, 0]
      edge.relative_position(p).must_equal 1
      edge.point_to_the_left?(p).must_equal true
    end

    it "returns -1 if point is to the right of the edge" do
      p = Point[5, 0]
      edge.relative_position(p).must_equal -1
      edge.point_to_the_left?(p).must_equal false
    end

    it "returns 0 if the point is on the line" do
      p = Point[0, 1]
      edge.relative_position(p).must_equal 0
      edge.point_to_the_left?(p).must_equal false
    end
  end

  describe "#angle_between" do
    let(:edge) { Edge.new(Point[0, 0], Point[0, 1]) }

    it "calculates the angle to a vector" do
      edge.angle_between(Vector2D[1, 0]).must_be_close_to Math::PI / 2, 1e-6
    end

    it "calculates the angle to a edge" do
      other_edge = Edge.new(Point[0, 0], Point[0, -1])
      edge.angle_between(other_edge).must_be_close_to Math::PI, 1e-6
    end
  end

end
