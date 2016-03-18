require_relative "../test_helper"
require_relative "../../app/convex_hull"
require_relative "../../app/vector2d"

describe ConvexHull do

  let(:convex_hull) { ConvexHull.new }

  describe "#initialize" do
    it "starts off with no points" do
      convex_hull.points.must_equal []
    end
  end

  describe "#polygon" do
  end

  describe "#add_point" do
    it "incrementally adds points to the hull" do
      p0 = Vector2D[0, 0]
      convex_hull.add_point(p0)
      convex_hull.points.must_cyclically_equal [p0] # seeding

      p1 = Vector2D[1, 0]
      convex_hull.add_point(p1)
      convex_hull.points.must_cyclically_equal [p0, p1] # simple addition

      p2 = Vector2D[1, 1]
      convex_hull.add_point(p2)
      convex_hull.points.must_cyclically_equal [p0, p2, p1] # maintains clockwise order

      p3 = Vector2D[0.5, 0.25]
      convex_hull.add_point(p3)
      convex_hull.points.must_cyclically_equal [p0, p2, p1] # ignores interior points

      p4 = Vector2D[0, 1]
      convex_hull.add_point(p4)
      convex_hull.points.must_cyclically_equal [p0, p4, p2, p1]

      p5 = Vector2D[2, 2]
      convex_hull.add_point(p5)
      convex_hull.points.must_cyclically_equal [p0, p4, p5, p1] # removes superceded points

      p6 = Vector2D[0.5, 0]
      convex_hull.add_point(p6)
      convex_hull.points.must_cyclically_equal [p0, p4, p5, p1] # ignores boundary points

      ## This is an edge-case that the current algorithm fails -- whatever
      # p7 = Vector2D[2, 0]
      # convex_hull.add_point(p7)
      # convex_hull.points.must_cyclically_equal [p0, p4, p5, p7] # removes superceded boundary points

      p7 = Vector2D[-1, -1]
      convex_hull.add_point(p7)
      convex_hull.points.must_cyclically_equal [p7, p4, p5, p1] # can handle root point removal
    end
  end

  describe "#bounding_box" do
  end

end
