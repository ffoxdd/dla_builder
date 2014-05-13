require_relative "../test_helper.rb"

shared_examples_for "A Point" do

  describe "value methods (#x, #y)" do
    it "returns initialized values" do
      point = factory.call(1, 2)

      point.x.must_equal 1
      point.y.must_equal 2
    end
  end

end
