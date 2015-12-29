require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/hierarchical_triangulation"

describe Triangulation::HierarchicalTriangulation do

  describe "#points" do
    let(:hierarchical_triangulation) { Triangulation::HierarchicalTriangulation.new }

    it "starts out with only boundary points" do
      hierarchical_triangulation.point_enumerator.size.must_equal(4)
    end
  end

  describe "#add_point" do
    let(:hierarchical_triangulation) { Triangulation::HierarchicalTriangulation.new }
    let(:point) { Point[0, 0] }

    it "adds a point to the hierarchy" do
      hierarchical_triangulation.add_point(point)
      hierarchical_triangulation.point_enumerator.include?(point).must_equal(true)
    end

    it "can add more than one point" do
      3.times { |n| hierarchical_triangulation.add_point(Point[0, 1 + n]) }
      hierarchical_triangulation.vertex_enumerator.size.must_equal(4 + 3)
    end
  end

end
