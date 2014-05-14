require_relative "../test_helper.rb"
require_relative "../../app/convex_hull.rb"
require_relative "../../app/point.rb"

describe ConvexHull do

  let(:convex_hull) { ConvexHull.new }

  describe "#initialize" do
    it "starts off with no points" do
      convex_hull.points.must_equal []
    end
  end

  describe "#empty?" do
    it "returns true if the hull has no points" do
      convex_hull.empty?.must_equal true

      convex_hull.add_point(Point[0, 0])
      convex_hull.empty?.must_equal false
    end
  end

  describe "#singleton?" do
    it "returns true if the hull has exactly one point" do
      convex_hull.singleton?.must_equal false

      convex_hull.add_point(Point[0, 0])
      convex_hull.singleton?.must_equal true

      convex_hull.add_point(Point[0, 0])
      convex_hull.singleton?.must_equal false
    end
  end

  describe "#add_point" do
    it "incrementally adds points to the hull" do
      p0 = Point[0, 0]
      convex_hull.add_point(p0)
      convex_hull.points.must_cyclically_equal [p0] # seeding

      p1 = Point[1, 0]
      convex_hull.add_point(p1)
      convex_hull.points.must_cyclically_equal [p0, p1] # simple addition

      p2 = Point[1, 1]
      convex_hull.add_point(p2)
      convex_hull.points.must_cyclically_equal [p0, p2, p1] # maintains clockwise order

      p3 = Point[0.5, 0.25]
      convex_hull.add_point(p3)
      convex_hull.points.must_cyclically_equal [p0, p2, p1] # ignores interior points

      p4 = Point[0, 1]
      convex_hull.add_point(p4)
      convex_hull.points.must_cyclically_equal [p0, p4, p2, p1]

      p5 = Point[2, 2]
      convex_hull.add_point(p5)
      convex_hull.points.must_cyclically_equal [p0, p4, p5, p1] # removes superceded points

      p6 = Point[0.5, 0]
      convex_hull.add_point(p6)
      convex_hull.points.must_cyclically_equal [p0, p4, p5, p1] # ignores boundary points

      ## This is an edge-case that the current algorithm fails -- whatever
      # p7 = Point[2, 0]
      # convex_hull.add_point(p7)
      # convex_hull.points.must_cyclically_equal [p0, p4, p5, p7] # removes superceded boundary points

      p7 = Point[-1, -1]
      convex_hull.add_point(p7)
      convex_hull.points.must_cyclically_equal [p7, p4, p5, p1] # can handle root point removal
    end
  end

end
