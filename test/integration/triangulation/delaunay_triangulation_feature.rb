require_relative "../../test_helper.rb"
require_relative '../../../app/triangulation/delaunay_triangulation.rb'
require_relative '../../../app/point'
require_relative '../../../app/dcel/mesh_svg_file'

describe "Delaunay Triangulation" do

  RADIUS = 200.0
  DIMENSIONS = [500, 500]

  def sample_point
    Point[rand(-RADIUS..RADIUS), rand(-RADIUS..RADIUS)]
  end

  it "triangulates a set of points" do
    points = 100.times.map { sample_point }
    triangulation = Triangulation::DelaunayTriangulation.new(points)

    DCEL::MeshSVGFile.new(triangulation, dimensions: DIMENSIONS).save
    triangulation.vertex_enumerator.to_a.size.must_equal(points.size)
  end

end
