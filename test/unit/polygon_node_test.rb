require_relative "../test_helper.rb"
require_relative "../../app/polygon_node.rb"

describe PolygonNode do

  describe "#initialize" do
    it "can be initialized with a point" do
      point = Point[0, 0]
      node = PolygonNode.new(point: point)
      node.points.must_equal [point]
    end

    it "can be initialized with a linked list" do
      point = Point[0, 0]
      linked_list = LinkedList.new(point)
      node = PolygonNode.new(linked_list: linked_list)
      node.points.must_equal [point]
    end

    it "allows linkages to be specified" do
      previous_point, point, next_point = Point[0, 0], Point[0, 0], Point[0, 0]

      previous_node = PolygonNode.new(point: previous_point)
      next_node = PolygonNode.new(point: next_point)

      node = PolygonNode.new(point: point, previous_node: previous_node, next_node: next_node)
      previous_node.points.must_equal [previous_point, point, next_point]
    end
  end

  describe ".build" do
    it "builds a connected set of nodes based on a list of points" do
      points = [Point[0, 0], Point[0, 0], Point[0, 0]]
      node = PolygonNode.build(*points)
      node.points.must_cyclically_equal points
    end
  end

  # TODO: test :singleton?, :self_link

  describe "#previous_node/#next_node" do
    it "provides access to adjacent nodes" do
      previous_node = PolygonNode.new(point: Point[0, 0])
      next_node = PolygonNode.new(point: Point[0, 0])
      node = PolygonNode.new(point: Point[0, 0], previous_node: previous_node, next_node: next_node)

      node.previous_node.point.must_equal previous_node.point
      node.next_node.point.must_equal next_node.point
    end
  end

end
