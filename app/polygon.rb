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

  # def extreme_point_enumerators
  #   ExtremePointEnumeratorFinder.new(nodes).enumerators
  # end

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

    # def insert_before(point, node)
    #   insert_point(point, node.previous_node, node)
    # end

    # class ExtremePointEnumeratorFinder
    #   def initialize(nodes)
    #     @nodes = nodes
    #     @min_x, @max_x, @min_y, @max_y = nil
    #     test_all_nodes
    #   end
    #
    #   def enumerators
    #     [ [min_x.next_enumerator, max_x.next_enumerator],
    #       [min_y.next_enumerator, max_y.next_enumerator] ]
    #   end
    #
    #   private
    #     attr_reader :nodes
    #     attr_accessor :min_x, :max_x, :min_y, :max_y
    #
    #     def test_all_nodes
    #       nodes.each { |node| test_node(node) }
    #     end
    #
    #     def test_node(node)
    #       self.min_x = [min_x, node].compact.min_by { |node| node.element.x }
    #       self.max_x = [max_x, node].compact.max_by { |node| node.element.x }
    #       self.min_y = [min_y, node].compact.min_by { |node| node.element.y }
    #       self.max_y = [max_y, node].compact.max_by { |node| node.element.y }
    #     end
    #
    #     def next_edge_enumerator(node)
    #       node.next_enumerator.tap do |enum|
    #         Enumerator.new do |y|
    #           node = enum.next
    #           loop { yield(node.element node.next_edge  } # not gonna work -- need PolygonNode
    #         end
    #       end
    #     end
    # end

end
