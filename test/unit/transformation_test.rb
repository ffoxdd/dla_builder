require_relative "../test_helper.rb"
require_relative "../../app/transformation.rb"

describe Transformation do
  describe "#intialize" do
    it "does not blow up" do
      -> { Transformation.new }.must_be_silent
    end
  end

  describe "#==" do
  end
end
