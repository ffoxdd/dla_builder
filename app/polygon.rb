require_relative "linked_list"
require_relative "polygon_node"
require_relative "edge"

class Polygon

  def initialize(*points)
    points.each { |point| add_point(point) }
  end

  def add_point(point)
    seed(point) and return if empty?
    add_to_end(point)
  end

  def insert_point(point, n0, n1)
    self.root = new_vertex(point, previous_node: n0, next_node: n1)
  end

  def points
    return [] if empty?
    root.points
  end

  def degenerate?
    empty? || singleton?
  end

  def find_previous(&block)
    return if empty?
    root.previous_enumerator.find(&block)
  end

  def find_next(&block)
    return if empty?
    root.next_enumerator.find(&block)
  end

  attr_reader :min_nodes, :max_nodes

  private

    attr_accessor :root
    attr_writer :min_nodes, :max_nodes

    def add_to_end(point)
      old_end = root.previous_node
      new_vertex(point, previous_node: old_end, next_node: root)
    end

    def seed(point)
      self.root = new_vertex(point)
      root.self_link
    end

    def new_vertex(point, attributes = {})
      PolygonNode.new(attributes.merge(point: point)).tap { |node| check_bounding_nodes(node) }
    end

    def check_bounding_nodes(node)
      self.min_nodes = [min(node, 0), min(node, 1)]
      self.max_nodes = [max(node, 0), max(node, 1)]
    end

    def min(node, dimension)
      return node if empty?
      [min_nodes[dimension], node].min_by { |n| n[dimension] }
    end

    def max(node, dimension)
      return node if empty?
      [max_nodes[dimension], node].max_by { |n| n[dimension] }
    end

    def last_node
      root.previous_node
    end

    def empty?
      !root
    end

    def singleton?
      return false if empty?
      root.singleton?
    end

end
