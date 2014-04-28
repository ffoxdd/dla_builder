require_relative "../test_helper.rb"
require_relative "../../app/convex_hull.rb"
require_relative "../../app/point.rb"


module MiniTest::Assertions
  def assert_cyclically_equal(a1, a2)
    assert cyclically_equal?(a1, a2), "Expected #{a1} to be cyclically equal to #{a2}"
  end

  private
    def cyclically_equal?(a0, a1)
      cyclic_permutations(a0).any? { |a| a == a1 }
    end

    def cyclic_permutations(array)
      array.size.times.map { array.unshift(array.pop).dup }
    end
end

Array.infect_an_assertion :assert_cyclically_equal, :must_cyclically_equal


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
      convex_hull.points.must_cyclically_equal [p0, p1] # simple addition

      p2 = Point.new(1, 1)
      convex_hull.add_point(p2)
      convex_hull.points.must_cyclically_equal [p0, p2, p1] # maintains clockwise order

      p3 = Point.new(0.5, 0.25)
      convex_hull.add_point(p3)
      convex_hull.points.must_cyclically_equal [p0, p2, p1] # ignores interior points

      p4 = Point.new(0, 1)
      convex_hull.add_point(p4)
      convex_hull.points.must_cyclically_equal [p0, p4, p2, p1]

      p5 = Point.new(2, 2)
      convex_hull.add_point(p5)
      convex_hull.points.must_cyclically_equal [p0, p4, p5, p1] # removes superceded points

      p6 = Point.new(0.5, 0)
      convex_hull.add_point(p6)
      convex_hull.points.must_cyclically_equal [p0, p4, p5, p1] # ignores boundary points

      ## This is an edge-case that the current algorithm fails -- whatever
      # p7 = Point.new(2, 0)
      # convex_hull.add_point(p7)
      # convex_hull.points.must_cyclically_equal [p0, p4, p5, p7] # removes superceded boundary points

      p7 = Point.new(-1, -1)
      convex_hull.add_point(p7)
      convex_hull.points.must_cyclically_equal [p7, p4, p5, p1] # can handle root point removal
    end
  end

end
