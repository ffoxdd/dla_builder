require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/hierarchical_triangulator"
require_relative "../../../app/point"
require "set"

describe Triangulation::HierarchicalTriangulator do

  describe ".mesh" do
    let(:points) { [Point[0, 0], Point[1, 0], Point[0, 1]] }

    it "returns a triangulation mesh" do
      mesh = Triangulation::HierarchicalTriangulator.mesh(points)
      mesh.vertex_value_enumerator.size.must_equal(6) # includes boundary points
    end
  end

end
