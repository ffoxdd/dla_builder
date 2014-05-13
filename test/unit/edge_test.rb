require_relative "../test_helper.rb"
require_relative "../../app/edge.rb"

describe Edge do

  describe "#displacement_vector" do
    it "returns a vector representing the displacement between the two vertices" do
      edge = Edge[[1, 1], [2, 3]]
      edge.displacement_vector.must_equal Vector2D[1, 2]
    end
  end

  describe "#relative_position/#point_to_the_left?" do
    let(:e0) { Point[0, 0] }
    let(:e1) { Point[0, 3] }
    let(:edge) { Edge[e0, e1] }

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

  describe "#angle" do
    it "returns the angle of the edge relative to [1, 0]" do
      edge = Edge[[2, 2], [2, 3]]
      edge.angle.must_be_close_to Math::PI / 2, 1e-6
    end
  end

end
