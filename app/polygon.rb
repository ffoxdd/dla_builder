require_relative "linked_list"
require_relative "polygon_node"
require_relative "edge"

class Polygon

  def initialize(*points)
    self.root = PolygonNode.build(*points)
  end

  def add_point(point)
    seed(point) and return if empty?
    add_to_end(point)
  end

  def insert_point(point, n0, n1)
    PolygonNode.new(point: point, previous_node: n0, next_node: n1)
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
    root.previous_enumerator.find { |node| yield(node) }
  end

  def find_next(&block)
    return if empty?
    root.next_enumerator.find { |node| yield(node) }
  end

  private

    attr_accessor :root

    def add_to_end(point)
      old_end = root.previous_node
      PolygonNode.new(point: point, previous_node: old_end, next_node: root)
    end

    def last_node
      root.previous_node
    end

    def seed(point)
      self.root = PolygonNode.new(point: point)
      root.self_link
    end

    def empty?
      !root
    end

    def singleton?
      return false if empty?
      root.singleton?
    end

end
