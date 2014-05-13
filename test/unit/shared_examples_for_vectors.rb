require_relative "../test_helper.rb"

shared_examples_for "A Vector" do

  describe "#to_a" do
    it "returns the elements as an array" do
      factory.call(6, 7).to_a.must_equal [6, 7]
    end
  end

  describe "#==" do
    it "returns true for equal vectors" do
      factory.call(1, 3).must_equal factory.call(1, 3)
      (factory.call(2, 5) == factory.call(4, 6)).must_equal false
    end
  end

  describe "#+" do
    it "adds, element-wise" do
      (factory.call(1, 1) + factory.call(3, 4)).must_equal factory.call(4, 5)
    end
  end

  describe "#-" do
    it "subtracts, element-wise" do
      (factory.call(1, 1) - factory.call(3, 4)).must_equal factory.call(-2, -3)
    end
  end

  describe "#map" do
    it "maps the elements" do
      vector = factory.call(1, 2)
      doubled = vector.map { |e| e * 2 }
      doubled.must_equal factory.call(2, 4)
    end
  end

  describe "#magnitude" do
    it "returns the magnitude of the vector" do
      factory.call(3, 4).magnitude.must_equal 5
    end
  end

  describe "#determinant" do
    it "returns the determinant of two vectors" do
      v0 = factory.call(1, 2)
      v1 = factory.call(3, 4)

      v0.determinant(v1).must_equal -2
    end
  end

  describe "#[]" do
    it "allows indexing" do
      v = factory.call(2, 3)

      v[0].must_equal 2
      v[1].must_equal 3
      v[2].must_equal nil
    end
  end

  describe "#rotate" do
    it "rotates the vector the specified radians" do
      vector = factory.call(1, 0)
      rotated_vector = vector.rotate(Math::PI / 2)

      rotated_vector[0].must_be_close_to 0, 1e-6
      rotated_vector[1].must_be_close_to 1, 1e-6
    end
  end

end
