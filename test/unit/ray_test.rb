require_relative "../test_helper.rb"
require_relative "../../app/ray.rb"
require_relative "../../app/point.rb"

describe Ray do

  describe ".from_endpoints" do
    # TODO
  end

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

  describe "#right_handed_orientation?" do
    let(:ray) { Ray.new(Point[0, 0], Vector2D[1, 1]) }

    it "returns true if the second ray is oriented to the left" do
      second_ray = Ray.new(Point[0, 0], Vector2D[0, 1])
      ray.right_handed_orientation?(second_ray).must_equal(true)
    end

    it "returns true if the second ray is oriented to the right" do
      second_ray = Ray.new(Point[0, 0], Vector2D[1, 0])
      ray.right_handed_orientation?(second_ray).must_equal(false)
    end
  end

  describe "#angle_to" do
    let(:ray) { Ray.new(Point[0, 0], Vector2D[0, 1]) }

    it "calculates the angle to a vector" do
      ray.angle_to(Vector2D[1, 0]).must_be_close_to Math::PI / 2, 1e-6
    end

    it "calculates the angle to a ray" do
      other_ray = Ray.new(Point[0, 0], Vector2D[0, -1])
      ray.angle_to(other_ray).must_be_close_to Math::PI, 1e-6
    end
  end

  describe "#right_handed?" do
    let(:ray) { Ray.new(Point[0, 0], Vector2D[1, 0]) }

    it "returns true for a right-handed vector" do
      ray.right_handed?(Vector2D[0, 1]).must_equal true
    end

    it "returns false for a left-handed vector" do
      ray.right_handed?(Vector2D[0, -1]).must_equal false
    end

    it "can calculate handedness for a ray" do
      other_ray = Ray.new(Point[0, 0], Vector2D[0 ,1])
      ray.right_handed?(other_ray).must_equal true
    end
  end

  describe "#==" do
    it "returns true when both the point and displacement vectors are identical" do
      Ray.new(Point[0, 0], Vector2D[0, 1]).must_equal Ray.new(Point[0, 0], Vector2D[0, 1])

      Ray.new(Point[0, 0], Vector2D[0, 1]).wont_equal Ray.new(Point[2, 0], Vector2D[0, 1])
      Ray.new(Point[0, 0], Vector2D[0, 1]).wont_equal Ray.new(Point[0, 0], Vector2D[1, 1])
    end

    it "handles equivalent rays with differing representations" do
      Ray.new(Point[0, 0], Vector2D[0, 1]).must_equal Ray.new(Point[0, 0], Vector2D[0, 2])
    end
  end

  describe "#rotate" do
    it "rotates the ray" do
      ray = Ray.new(Point[0, 0], Vector2D[0, 1])
      rotated_ray = ray.rotate(Math::PI)

      rotated_ray.displacement_vector[0].must_be_close_to 0, 1e-6
      rotated_ray.displacement_vector[1].must_be_close_to -1, 1e-6

      rotated_ray.point.must_equal Point[0, 0]
    end
  end

  describe "#intersection" do
    it "returns the point of intersection with another ray" do
      r1 = Ray.new(Point[1, 0], Vector2D[1, 0])
      r2 = Ray.new(Point[1, 1], Vector2D[0, 1])

      r1.intersection(r2).must_equal Point[1, 0]
    end

    it "returns nil for parallel rays" do
      r1 = Ray.new(Point[1, 0], Vector2D[1, 0])
      r2 = Ray.new(Point[2, 0], Vector2D[1, 0])

      r1.intersection(r2).must_equal nil
    end
  end

end
