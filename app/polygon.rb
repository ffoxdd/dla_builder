require_relative "linked_list"
require_relative "edge"

class Polygon

  def initialize(*points)
    return if points.empty?
    seed(points.shift)
    root.tap { |start| points.each { |point| insert_before(point, start) }}
  end

  def add_point(point)
    seed(point) and return if empty?
    insert_before(point, root)
  end

  def points
    next_enumerator.map(&:element)
  end

  def degenerate?
    empty? || singleton?
  end

  def find_next(&block)
    next_enumerator.find { |node| yield(node.element, previous_edge(node), next_edge(node)) }
  end

  def find_previous(&block)
    previous_enumerator.find { |node| yield(node.element, previous_edge(node), next_edge(node)) }
  end

  alias_method :find, :find_next

  def insert_point(point, n0, n1)
    insert_node(LinkedList.new(point), n0, n1)
  end

  def extreme_points
    ExtremePointFinder.new(points).extreme_points
  end

  private

    attr_accessor :root

    def previous_enumerator
      linked_list_enumerator(:previous_enumerator)
    end

    def next_enumerator
      linked_list_enumerator(:next_enumerator)
    end

    def linked_list_enumerator(enumerator_method)
      return Enumerator.new { } if empty?
      root.send(enumerator_method)
    end

    def seed(point)
      self.root = LinkedList.new(point)
      self_link(root)
    end

    def self_link(node)
      node.link_next(node)
      node.link_previous(node)
    end

    def empty?
      !root
    end

    def singleton?
      return false if empty?
      root.next_node == root
    end

    def insert_node(node, n0, n1)
      n0.link_next(node)
      n1.link_previous(node)
      self.root = node
    end

    def previous_edge(node)
      Edge.new(node.previous_pair)
    end

    def next_edge(node)
      Edge.new(node.next_pair)
    end

    def insert_before(point, node)
      insert_point(point, node.previous_node, node)
    end

    class ExtremePointFinder
      def initialize(points)
        @points = points
        @min_x, @max_x, @min_y, @max_y = nil
        test_all_points
      end

      def extreme_points
        [[min_x, max_x], [min_y, max_y]]
      end

      private
        attr_reader :points
        attr_accessor :min_x, :max_x, :min_y, :max_y

        def test_all_points
          points.each { |point| test_point(point) }
        end

        def test_point(point)
          self.min_x = [min_x, point].compact.min_by(&:x)
          self.max_x = [max_x, point].compact.max_by(&:x)
          self.min_y = [min_y, point].compact.min_by(&:y)
          self.max_y = [max_y, point].compact.max_by(&:y)
        end
    end

end
