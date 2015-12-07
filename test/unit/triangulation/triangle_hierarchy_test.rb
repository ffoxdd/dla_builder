require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/triangle_hierarchy"

describe Triangulation::TriangleHierarchy do

  describe "#vertices" do
    let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }

    it "starts out with no vertices" do
      triangle_hierarchy.vertices.must_equal([])
    end
  end

  # describe "#add_point" do
  #   let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }
  #
  #   it "Adds a point to the hierarchy" do
  #   end
  # end

end
