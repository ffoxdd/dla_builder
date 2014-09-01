require_relative "../test_helper.rb"
require_relative "../../app/bounding_box_finder.rb"
require_relative "../../app/bounding_box.rb"
require_relative "../../app/polygon.rb"
require_relative "../../app/point.rb"

describe BoundingBoxFinder do

  let(:polygon) { Polygon.new(Point[0, 0], Point[-1, 1], Point[1, 1]) }

  describe "#bounding_box" do
    it "finds a minimum-perimeter bounding box" do
      finder = BoundingBoxFinder.new(polygon)
      finder.bounding_box.perimeter.must_be_close_to Math.sqrt(2) * 4, 1e-10
    end
  end

end
