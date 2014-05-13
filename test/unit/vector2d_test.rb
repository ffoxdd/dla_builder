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

end
