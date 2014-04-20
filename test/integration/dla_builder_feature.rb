require_relative "../test_helper.rb"
require_relative '../../app/dla_builder.rb'

describe "DLA Builder" do

  it "builds by particle limit" do
    dla = DlaBuilder.new(limit: 10).build
    dla.size.must_equal 10
  end

  it "builds by bounding box" do
    bounding_box = BoundingBox.new(-20..20, -20..20)
    dla = DlaBuilder.new(within: bounding_box).build
    dla.size.must_be :>, 3
  end

end
