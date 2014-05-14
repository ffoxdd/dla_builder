require_relative "../test_helper.rb"
require_relative "../../app/bounding_box_finder.rb"
require_relative "../../app/bounding_box.rb"
require_relative "../../app/convex_hull.rb"
require_relative "../../app/point.rb"

describe BoundingBoxFinder do

  describe "#bounding_box" do
    let(:convex_hull) { ConvexHull.new }

    it "returns nil for an empty hull" do
      finder = BoundingBoxFinder.new(convex_hull)
      finder.bounding_box.must_equal nil
    end

    it "returns nil for a singleton hull" do
      convex_hull.add_point(Point[0, 0])
      finder = BoundingBoxFinder.new(convex_hull)
      finder.bounding_box.must_equal nil
    end
  end

end
