require_relative "linked_list"
require 'forwardable'

class ConvexHull

  include Enumerable
  extend Forwardable

  alias_method :points, :to_a

  def add_point(point)
    seed(point) and return if empty?
    insert_point(point, root, root) and return if singleton?

    add_to_hull(point)
  end

  def each
    next_enumerator.each { |node| yield(node.element) }
  end

  private

    attr_accessor :root

    def previous_enumerator
      linked_list_enumerator(&:previous_node)
    end

    def next_enumerator
      linked_list_enumerator(&:next_node)
    end

    def linked_list_enumerator(&iterator)
      Enumerator.new do |y|
        next if empty?

        root.tap do |current_node|
          loop do
            y.yield(current_node)
            current_node = iterator.call(current_node)
            break if current_node == root
          end
        end
      end
    end

    def add_to_hull(point)
      insert_point(point, lower_tangency_node(point), upper_tangency_node(point))
    end

    def singleton?
      root.next_node == root
    end

    def empty?
      !root
    end

    def upper_tangency_node(point)
      find_next { |node| upper_tangency_point?(point, node) }
    end

    def lower_tangency_node(point)
      find_previous { |node| lower_tangency_point?(point, node) }
    end

    def find_next(&block)
      next_enumerator.find { |node| yield(node) }
    end

    def find_previous(&block)
      previous_enumerator.find { |node| yield(node) }
    end

    def upper_tangency_point?(point, node)
      can_see?(point, node.previous_edge) && !can_see?(point, node.next_edge)
    end

    def lower_tangency_point?(point, node)
      !can_see?(point, node.previous_edge) && can_see?(point, node.next_edge)
    end

    def can_see?(point, edge)
      point.left_of?(edge)
    end

    def seed(point)
      self.root = LinkedList.new(point)
      self_link(root)
    end

    def self_link(node)
      node.link_next(node)
      node.link_previous(node)
    end

    def insert_point(point, n0, n1)
      return unless n0 && n1

      node = LinkedList.new(point)
      n0.link_next(node)
      n1.link_previous(node)
      self.root = node
    end

end
