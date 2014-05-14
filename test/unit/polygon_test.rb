require_relative "../test_helper.rb"
require_relative "../../app/polygon.rb"
require_relative "../../app/point.rb"
require 'set'

describe Polygon do

  let(:polygon) { Polygon.new }

  describe "#initialize" do
    it "starts off with no points" do
      polygon.points.must_equal []
    end

    it "allows specifying initial points" do
      polygon = Polygon.new(Point[0, 0], Point[0, 1], Point[1, 0])
      polygon.points.must_cyclically_equal [Point[0, 0], Point[0, 1], Point[1, 0]]
    end
  end

  describe "#degenerate?" do
    it "returns true if the polygon has 0 or 1 point (i.e. no edges)" do
      polygon.degenerate?.must_equal true

      polygon.add_point(Point[0, 0])
      polygon.degenerate?.must_equal true

      polygon.add_point(Point[1, 0])
      polygon.degenerate?.must_equal false
    end
  end

  describe "#add_point" do
    it "adds points to the polygon" do
      p0 = Point[0, 0]
      polygon.add_point(p0)
      polygon.points.must_cyclically_equal [p0]

      p1 = Point[1, 0]
      polygon.add_point(p1)
      polygon.points.must_cyclically_equal [p0, p1]

      # note that order is not maintained after n=2

      p2 = Point[2, 0]
      polygon.add_point(p2)
      Set.new(polygon.points).must_equal Set.new([p0, p1, p2])
    end
  end

  describe "#find/find_next/find_previous" do

    it "finds nodes in the polygon by their point" do
      polygon = test_square

      node = polygon.find { |point| point == Point[1, 0] }
      node.element.must_equal Point[1, 0]

      node = polygon.find_next { |point| point == Point[0, 1] }
      node.element.must_equal Point[0, 1]

      node = polygon.find_previous { |point| point == Point[1, 1] }
      node.element.must_equal Point[1, 1]
    end

    it "finds by edges" do
      polygon = test_square

      node = polygon.find { |point, previous_edge, next_edge| previous_edge.angle == 0 }
      node.element.must_equal Point[1, 1]

      node = polygon.find { |point, previous_edge, next_edge| next_edge.angle == 0 }
      node.element.must_equal Point[0, 1]
    end
  end

  describe "#insert_point" do
    it "inserts the point between the specified nodes" do
      polygon = test_square

      n0 = polygon.find { |point| point == Point[0, 1] }
      n1 = polygon.find { |point| point == Point[1, 0] }

      polygon.insert_point(Point[2, 2], n0, n1)

      polygon.points.must_cyclically_equal(
        [Point[0, 0], Point[0, 1], Point[2, 2], Point[1, 0]]
      )
    end
  end

end

def test_square
  Polygon.new(
    Point[0, 0], Point[0, 1], Point[1, 1], Point[1, 0]
  )
end
