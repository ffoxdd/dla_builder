require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/triangle_hierarchy"

describe Triangulation::TriangleHierarchy do

  describe "#points" do
    let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }

    it "starts out with no points" do
      triangle_hierarchy.points.must_equal([])
    end
  end

  describe "#add_point" do
    let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }
    let(:point) { Point[0, 0] }

    it "Adds a point to the hierarchy" do
      triangle_hierarchy.add_point(point)
      triangle_hierarchy.points.must_equal([point])
    end
  end

end
