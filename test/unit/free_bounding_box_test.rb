require_relative "../test_helper.rb"
require_relative "../../app/free_bounding_box.rb"
require_relative "../../app/point.rb"
require_relative "../../app/vector2d.rb"

describe FreeBoundingBox do

  describe "#bounding_box" do
    it "returns the untransformed bounding box" do
      free_bounding_box = FreeBoundingBox.new(0..1, 0..1)
      bounding_box = free_bounding_box.bounding_box

      bounding_box.x_range.must_equal 0..1
      bounding_box.y_range.must_equal 0..1
    end
  end

  def error(matrix, expected_matrix)
    (matrix - expected_matrix).inject(&:+)
  end

  describe "#transformation_matrix" do
    it "returns a matrix representing the box's coordinate transformation from the origin" do
      box = FreeBoundingBox.new(0..1, 0..1, rotation: Math::PI/2, translation: Vector2D[2, 2])
      matrix = box.transformation_matrix
      expected_matrix = Matrix[[0, -1, 2], [1, 0, 2], [0, 0, 1]]
      error(matrix, expected_matrix).must_be_close_to 0, 1e-10
    end
  end

  describe ".from_vertices" do
    it "builds a free bounding box from the locations of its four corners" do
      pi, rt2 = Math::PI, Math.sqrt(2)
      points = [Point[0, rt2/2], Point[rt2/2, rt2], Point[rt2, rt2/2], Point[rt2/2, 0]]
      free_bounding_box = FreeBoundingBox.from_vertices(points)

      free_bounding_box.bounding_box.must_equal BoundingBox.new(0..1, 0..1)
      [pi/4, -pi/4].must_include free_bounding_box.rotation
      [Vector2D[rt2/2, 0], Vector2D[0, rt2/2]].must_include free_bounding_box.translation
    end
  end

  describe "#perimeter" do
    it "returns the perimeter" do
      FreeBoundingBox.new(0..2, 0..3).perimeter.must_equal 10
    end
  end

end
