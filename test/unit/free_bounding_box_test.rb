require_relative "../test_helper.rb"
require_relative "../../app/free_bounding_box.rb"
require_relative "../../app/vector2d.rb"

describe FreeBoundingBox do

  describe "#transformation_matrix" do
    it "returns a matrix representing the box's coordinate transformation from the origin" do
      box = FreeBoundingBox.new(0..1, 0..1, rotation: Math::PI/2, translation: Vector2D[2, 2])
      matrix = box.transformation_matrix
      expected_matrix = Matrix[[0, -1, 2], [1, 0, 2], [0, 0, 1]]
      error_matrix = box.transformation_matrix - expected_matrix
      total_error = error_matrix.inject(&:+)

      total_error.must_be_close_to 0, 1e-10
    end
  end

end
