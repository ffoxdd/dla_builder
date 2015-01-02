require_relative "../test_helper.rb"
require_relative "../../app/vector2d.rb"
require_relative "../../app/transformation.rb"
require_relative "./shared_examples_for_vectors.rb"

describe Vector2D do

  it_behaves_like "A Vector" do
    let(:factory) { Vector2D.method(:[]) }
  end

  describe ".random" do
    it "builds a vector with the specified magnitude in a random direction" do
      Vector2D.random(3).magnitude.must_be_close_to 3, 0.00001
    end

    it "doesn't generate the same vector each time" do
      vector_1 = Vector2D.random(4)
      vector_2 = Vector2D.random(4)

      (vector_1 == vector_2).must_equal false
    end
  end

  describe "#inner_product" do
    it "returns the inner product of two vectors" do
      Vector2D[4, 7].inner_product(Vector2D[10, 1]).must_equal 47
    end
  end

  describe "#determinant" do
    it "returns the determinant of two vectors" do
      Vector2D[1, 2].determinant(Vector2D[3, 4]).must_equal -2
    end
  end

  describe "#+" do
    it "adds two vectors" do
      (Vector2D[1, 2] + Vector2D[3, 4]).must_equal Vector2D[4, 6]
    end
  end

  describe "#-" do
    it "subtracts two vectors" do
      (Vector2D[1, 2] - Vector2D[3, 4]).must_equal Vector2D[-2, -2]
    end
  end

  describe "#*" do
    it "performs scalar multiplication when given a scalar" do
      (Vector2D[1, 2] * -1).must_equal Vector2D[-1, -2]
    end

    it "applies a transformation when given a transformation object" do
      vector = Vector2D[1, 0]
      transformation = Transformation.new(rotation: Math::PI/2, translation: Vector2D[1, 1])
      (vector * transformation).must_equal Vector2D[1, 2]
    end
  end

  describe ".rotation_matrix" do
    it "returns a rotation matrix for the given theta" do
      matrix = Vector2D.rotation_matrix(Math::PI)
      expected_matrix = Matrix[[-1, 0], [0, -1]]
      error = (matrix - expected_matrix).map(&:abs).reduce(&:+)

      error.must_be_close_to 0, 1e-10
    end
  end

  describe "#rotate" do
    it "rotates the vector" do
      vector = Vector2D[0, 1].rotate(Math::PI)

      # needs matcher
      vector[0].must_be_close_to 0, 1e-10
      vector[1].must_be_close_to -1, 1e-10
    end
  end

  describe "#angle_to" do
    it "returns the angle between two vectors" do
      Vector2D[1, 0].angle_to(Vector2D[1, 0]).must_equal 0
      Vector2D[2, 0].angle_to(Vector2D[0, 3]).must_be_close_to Math::PI / 2, 1e-6
      Vector2D[1, 1].angle_to(Vector2D[-1, -1]).must_be_close_to Math::PI, 1e-6
    end
  end

  describe "#to_v" do
    it "returns the same object" do
      Vector2D[1, 2].to_v.must_equal Vector2D[1, 2]
    end
  end

  describe "#right_handed?" do
    it "returns true if the rhs lies in the right handed direction relative to the first" do
      Vector2D[1, 0].right_handed?(Vector2D[0, 1]).must_equal true
    end

    it "returns false if the rhs lies in the right handed direction relative to the first" do
      Vector2D[0, 1].right_handed?(Vector2D[1, 0]).must_equal false
    end

    it "returns true if the vectors are colinear" do
      Vector2D[1, 0].right_handed?(Vector2D[1, 0]).must_equal true
    end
  end

  describe "#signed_angle_to" do
    it "returns a positive angle to a right-handed vector" do
      Vector2D[1, 0].signed_angle_to(Vector2D[0, 1]).must_equal Math::PI/2
    end

    it "returns a negative angle to a left-handed vector" do
      Vector2D[1, 0].signed_angle_to(Vector2D[0, -1]).must_equal -Math::PI/2
    end
  end

  describe "#-@" do
    it "returns a direction with equal magnitude in the opposite direction" do
      (-Vector2D[1, 2]).must_equal(Vector2D[-1, -2])
    end
  end

end
