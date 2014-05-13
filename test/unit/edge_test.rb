require_relative "../test_helper.rb"
require_relative "../../app/edge.rb"

describe Edge do

  describe "#displacement_vector" do
    it "returns a vector representing the displacement between the two vertices" do
      edge = Edge[[1, 1], [2, 3]]
      edge.displacement_vector.must_equal Vector2D[1, 2]
    end
  end

  describe "#relative_position" do
    let(:e0) { Point[0, 0] }
    let(:e1) { Point[0, 3] }
    let(:edge) { Edge[e0, e1] }

    it "returns 1 if point is to the left of the edge" do
      edge.relative_position(Point[-1, 0]).must_equal 1
    end

    it "returns -1 if point is to the right of the edge" do
      edge.relative_position(Point[5, 0]).must_equal -1
    end

    it "returns 0 if the point is on the line" do
      edge.relative_position(Point[0, 1]).must_equal 0
    end
  end

end
