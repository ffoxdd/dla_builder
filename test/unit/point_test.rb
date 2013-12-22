require_relative "../test_helper.rb"
require_relative "./shared_examples_for_points.rb"
require_relative "../../app/point.rb"

describe Point do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { Point.new(0, 0) }.must_be_silent
    end
  end

  it_behaves_like "A Point" do
    let(:factory) { Point.method(:new) }
  end

end
