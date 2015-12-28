require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/triangle_hierarchy"

describe Triangulation::TriangleHierarchy do

  describe "#points" do
    let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }

    it "starts out with only boundary points" do
      triangle_hierarchy.point_enumerator.size.must_equal(3)
    end
  end

  describe "#add_point" do
    let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }
    let(:point) { Point[0, 0] }

    it "adds a point to the hierarchy" do
      triangle_hierarchy.add_point(point)
      triangle_hierarchy.point_enumerator.include?(point).must_equal(true)
    end

    it "can add more than one point" do
      3.times { |n| triangle_hierarchy.add_point(Point[0, 1 + n]) }
      triangle_hierarchy.vertex_enumerator.size.must_equal(3 + 3)
    end
  end

end
