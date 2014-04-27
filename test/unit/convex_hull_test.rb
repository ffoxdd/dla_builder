require_relative "../test_helper.rb"
require_relative "../../app/convex_hull.rb"
require_relative "../../app/point.rb"

describe ConvexHull do

  describe "#initialize" do
    it "starts off with a single point" do
      p0 = Object.new
      convex_hull = ConvexHull.new(p0)

      convex_hull.points.must_equal [p0]
    end
  end

  describe "#add_point" do
    it "incrementally adds points to the hull" do
      p0 = Point.new(0, 0)
      p1 = Point.new(1, 0)
      convex_hull = ConvexHull.new(p0)

      convex_hull.add_point(p1)
      convex_hull.points.must_equal [p0, p1]
    end
  end

end
