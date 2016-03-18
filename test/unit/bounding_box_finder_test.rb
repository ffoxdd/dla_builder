require_relative "../test_helper"
require_relative "../../app/bounding_box_finder"
require_relative "../../app/bounding_box"
require_relative "../../app/polygon"
require_relative "../../app/vector2d"

describe BoundingBoxFinder do

  let(:polygon) { Polygon.new(Vector2D[0, 0], Vector2D[-1, 1], Vector2D[1, 1]) }

  describe "#bounding_box" do
    it "finds a minimum-perimeter bounding box" do
      finder = BoundingBoxFinder.new(polygon)
      finder.bounding_box.perimeter.must_be_close_to Math.sqrt(2) * 4, 1e-10
      # TODO: assert result with a within delta matcher for bounding boxes
    end

    it "handles the 2-vertex case" do
      polygon = Polygon.new(Vector2D[0, 0], Vector2D[0, 1])
      finder = BoundingBoxFinder.new(polygon)
      finder.bounding_box.perimeter.must_equal 2
    end

    it "handes the 1-vertex case" do
      polygon = Polygon.new(Vector2D[1, 1])
      finder = BoundingBoxFinder.new(polygon)
      finder.bounding_box.perimeter.must_equal 0
    end
  end

end
