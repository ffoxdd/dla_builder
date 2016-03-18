require_relative "../../test_helper"
require_relative "../../../app/triangulation/hierarchical_triangle"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/vector2d"
require "set"

describe Triangulation::HierarchicalTriangle do

  let(:points) { [Vector2D[0, 0], Vector2D[10, 0], Vector2D[0, 10]] }
  let(:mesh) { DCEL::Mesh.cycle_graph(points) }
  let(:face) { mesh.faces.first }
  let(:triangle) { Triangulation::HierarchicalTriangle.new(mesh: mesh, graph_face: face) }

  describe "#points" do
    it "starts off with the points from the given face" do
      triangle.points.must_equal(points)
    end
  end

  describe "#add_point" do
    let(:new_point) { Vector2D[1, 1] }

    it "adds a point" do
      triangle.add_point(new_point)
      Set.new(triangle.points).must_equal(Set.new(points + [new_point]))
    end
  end

end
