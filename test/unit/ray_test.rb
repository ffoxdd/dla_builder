require_relative "../test_helper.rb"
require_relative "../../app/ray.rb"
require_relative "../../app/point.rb"

describe Ray do

  describe "#relative_position/#point_to_the_left?" do
    let(:ray) { Ray.new(Point[0, 0], Vector2D[0, 3]) }

    it "returns 1 if point is to the left of the ray" do
      p = Point[-1, 0]
      ray.relative_position(p).must_equal 1
      ray.point_to_the_left?(p).must_equal true
    end

    it "returns -1 if point is to the right of the ray" do
      p = Point[5, 0]
      ray.relative_position(p).must_equal -1
      ray.point_to_the_left?(p).must_equal false
    end

    it "returns 0 if the point is on the line" do
      p = Point[0, 1]
      ray.relative_position(p).must_equal 0
      ray.point_to_the_left?(p).must_equal false
    end
  end

end
