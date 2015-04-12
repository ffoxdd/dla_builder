require_relative "../test_helper.rb"
require_relative "../../app/transformation.rb"

describe Transformation do
  describe "#initialize" do
    it "does not blow up" do
      -> { Transformation.new }.must_be_silent
    end
  end

  describe "#apply" do
    describe "rotation" do
      it "applies the rotation to the given vector" do
        transformation = Transformation.new(rotation: Math::PI/2)

        vector = Vector2D[1, 0]
        result = transformation.apply(vector)

        result[0].must_be_close_to 0, 1e-10
        result[1].must_be_close_to 1, 1e-10
      end
    end

    describe "translation" do
      it "applies the translation to the given vector" do
        transformation = Transformation.new(translation: Vector2D[3, 5])
        vector = Vector2D[1, 2]
        result = transformation.apply(vector)

        result[0].must_be_close_to 4, 1e-10
        result[1].must_be_close_to 7, 1e-10
      end
    end

    describe "mixed" do
      it "applies the composed transformation, rotation first" do
        transformation = Transformation.new(rotation: Math::PI/2, translation: Vector2D[1, 1] )
        vector = Vector2D[1, 0]
        result = transformation.apply(vector)

        result[0].must_be_close_to 1, 1e-10
        result[1].must_be_close_to 2, 1e-10
      end
    end
  end
end
