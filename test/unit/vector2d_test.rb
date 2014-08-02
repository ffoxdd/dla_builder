require_relative "../test_helper.rb"
require_relative "../../app/vector2d.rb"
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

  ## TODO: make matcher for being close in 2d space
  # describe "#rotate" do
  #   it "rotates the vector" do
  #     Vector2D[0, 1].rotate(Math::PI).must_equal Vector2D[-1, 0]
  #   end
  # end

  describe "#angle" do
    it "returns the angle of the vector relative to [1, 0]" do
      Vector2D[1, 0].angle.must_be_close_to 0, 1e-6
      Vector2D[0, 1].angle.must_be_close_to Math::PI / 2, 1e-6
      Vector2D[-1, 1].angle.must_be_close_to 3 * Math::PI / 4, 1e-6
    end
  end

end
