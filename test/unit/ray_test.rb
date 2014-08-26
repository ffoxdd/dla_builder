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

  describe "angle_between" do
    let(:ray) { Ray.new(Point[0, 0], Vector2D[0, 1]) }

    it "calculates the angle to a vector" do
      ray.angle_between(Vector2D[1, 0]).must_be_close_to Math::PI / 2, 1e-6
    end

    it "calculates the angle to a ray" do
      other_ray = Ray.new(Point[0, 0], Vector2D[0, -1])
      ray.angle_between(other_ray).must_be_close_to Math::PI, 1e-6
    end
  end

end
