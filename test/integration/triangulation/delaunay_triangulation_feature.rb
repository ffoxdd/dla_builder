require_relative "../../test_helper.rb"
require_relative '../../../app/triangulation/delaunay_triangulation.rb'
require_relative '../../../app/vector2d'
require_relative '../../../app/dcel/mesh_svg_file'

describe "Delaunay Triangulation" do

  RADIUS = 200.0
  DIMENSIONS = [500, 500]

  def sample_point
    Vector2D[rand(-RADIUS..RADIUS), rand(-RADIUS..RADIUS)]
  end

  def points_grid
    (0..10).map do |x|
      (0..10).map { |y| Vector2D[x * 70, y * 70] }
    end.flatten
  end

  def random_walk(points)
    points.map { |p| p + Vector2D.random(1) }
  end

  it "triangulates a set of points" do
    points = points_grid
    250.times { points = random_walk(points) }

    triangulation = Triangulation::DelaunayTriangulation.new(points)

    DCEL::MeshSVGFile.new(triangulation).save
    # triangulation.vertex_enumerator.to_a.size.must_equal(points.size)
  end

end
