require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/hierarchical_triangle"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/point"
require "set"

describe Triangulation::HierarchicalTriangle do

  let(:points) { [Point[0, 0], Point[10, 0], Point[0, 10]] }
  let(:mesh) { DCEL::Mesh.polygon(points) }
  let(:face) { mesh.faces.first }
  let(:triangle) { Triangulation::HierarchicalTriangle.new(mesh: mesh, face: face) }

  describe "#points" do
    it "starts off with the points from the given face" do
      triangle.points.must_equal(points)
    end
  end

  describe "#add_point" do
    let(:new_point) { Point[1, 1] }

    it "adds a point" do
      triangle.add_point(new_point)
      Set.new(triangle.points).must_equal(Set.new(points + [new_point]))
    end
  end

end
