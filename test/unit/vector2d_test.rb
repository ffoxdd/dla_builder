require_relative "../test_helper.rb"
require_relative "../../app/vector2d.rb"

describe Vector2D do

  describe "#==" do
    it "returns true for equal vectors" do
      Vector2D[1, 3].must_equal Vector2D[1, 3]
      (Vector2D[2, 5] == Vector2D[4, 6]).must_equal false
    end
  end

  describe "#+" do
    it "adds, element-wise" do
      (Vector2D[1, 1] + Vector2D[3, 4]).must_equal Vector2D[4, 5]
    end
  end

  describe "#-" do
    it "subtracts, element-wise" do
      (Vector2D[1, 1] - Vector2D[3, 4]).must_equal Vector2D[-2, -3]
    end
  end

  describe "#magnitude" do
    it "returns the magnitude of the vector" do
      Vector2D[3, 4].magnitude.must_equal 5
    end
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

  describe "#determinant" do
    it "returns the determinant of two vectors" do
      v0 = Vector2D[1, 2]
      v1 = Vector2D[3, 4]

      v0.determinant(v1).must_equal -2
    end
  end

  describe "[]" do
    it "allows indexing" do
      v = Vector2D[2, 3]

      v[0].must_equal 2
      v[1].must_equal 3
      v[2].must_equal nil
    end
  end

  describe "#rotate" do
    it "rotates the vector, in radians" do
      result = Vector2D[1, 0].rotate(Math::PI / 2)
      result[0].must_be_close_to 0, 0.0001
      result[1].must_be_close_to 1, 0.0001
    end
  end

end
