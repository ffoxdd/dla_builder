require_relative "../test_helper.rb"
require_relative "../../app/canvas.rb"

describe Canvas do

  describe "#sketch_dimensions" do
    it "converts to pixels" do
      canvas = Canvas.new([100, 100], [5, 5])
      canvas.sketch_dimensions.must_equal [100, 100]
    end

    it "converts to pixels when the canvas is wider than the viewport" do
      canvas = Canvas.new([100, 100], [5, 1])
      canvas.sketch_dimensions.must_equal [100, 20]
    end

    it "converts to pixels when the canvas is wider than the viewport" do
      canvas = Canvas.new([100, 100], [1, 5])
      canvas.sketch_dimensions.must_equal [20, 100]
    end
  end

  describe "#mm_to_pixels" do
    it "converts mm to pixels" do
      canvas = Canvas.new([100, 100], [5, 5]) # 20px/in
      canvas.mm_to_pixels(25.4).must_equal 20.0
    end
  end

end
