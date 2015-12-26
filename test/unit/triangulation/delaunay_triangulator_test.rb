require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/delaunay_triangulator"
require_relative "../../../app/point"
require "set"

describe Triangulation::DelaunayTriangulator do

  # describe ".mesh" do
  #   let(:points) { [Point[0, 0], Point[1, 0], Point[0, 1]] }
  #
  #   it "returns a delaunay triangulation mesh" do
  #     mesh = Triangulation::DelaunayTriangulator.mesh(points)
  #     Set.new(mesh.vertex_values).must_equal(Set.new(points))
  #   end
  # end

  def sample_point
    Point[rand(-50..50.0), rand(-50..50.0)]
  end

  require 'timeout'
  require_relative "../../../app/triangulation/hierarchical_triangulator"
  require_relative "../../../app/triangulation/delaunay_triangulator"
  require_relative "../../../app/dcel/mesh_svg_file"

  it "looks sane" do
    points = 100.times.map { sample_point }

    # mesh = Triangulation::HierarchicalTriangulator.mesh(points)
    mesh = Triangulation::DelaunayTriangulator.mesh(points)
    DCEL::MeshSVGFile.new(mesh).save

    # Triangulation::DelaunayTriangulator.mesh(points)
  end

end
