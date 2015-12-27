require_relative "../../test_helper.rb"
require_relative '../../../app/triangulation/delaunay_triangulator.rb'

describe "Delaunay Triangulation" do

  def sample_point
    Point[rand(-50..50.0), rand(-50..50.0)]
  end

  it "triangulates a set of points" do
    points = 100.times.map { sample_point }
    mesh = Triangulation::DelaunayTriangulator.mesh(points)

    mesh.vertex_enumerator.size.must_equal(points.size + 3) # 3 boundary vertices
  end

end
