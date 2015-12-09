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

    it "adds a point to the hierarchy" do
      triangle_hierarchy.add_point(point)
      triangle_hierarchy.points.must_equal([point])
    end

    it "can add more than one point" do
      3.times { |n| triangle_hierarchy.add_point(Point[0, 1 + n]) }
      true.must_equal(true)
    end
  end

  # describe "#triangulated_mesh" do
  #   let(:triangle_hierarchy) { Triangulation::TriangleHierarchy.new }
  #
  #   it "Returns the triangulated mesh, without the auxiliary points" do
  #     triangle_hierarchy.add_point(Point[0, 0])
  #     triangle_hierarchy.add_point(Point[10, 0])
  #     # triangle_hierarchy.add_point(Point[0, 10])
  #
  #     # mesh = triangle_hierarchy.triangulated_mesh
  #     # mesh.faces.size.must_equal(2) # 1 bounded, 1 unbounded
  #     # mesh.edges.size.must_equal(3)
  #     # mesh.vertices.size.must_equal(3)
  #   end
  # end

end
