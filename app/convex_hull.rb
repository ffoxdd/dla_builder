require_relative "linked_list"
require_relative "edge"

class ConvexHull

  def add_point(point)
    seed(point) and return if empty?
    insert_point(point, root, root) and return if singleton?

    add_to_hull(point)
  end

  def points
    next_enumerator.map(&:element)
  end

  private

    attr_accessor :root

    def previous_enumerator
      enumerator(&:previous_enumerator)
    end

    def next_enumerator
      enumerator(&:next_enumerator)
    end

    def enumerator(&iterator)
      return Enumerator.new { } if empty?
      yield(root)
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
      can_see?(point, previous_edge(node)) && !can_see?(point, next_edge(node))
    end

    def lower_tangency_point?(point, node)
      !can_see?(point, previous_edge(node)) && can_see?(point, next_edge(node))
    end

    def previous_edge(node)
      Edge.new(node.previous_pair)
    end

    def next_edge(node)
      Edge.new(node.next_pair)
    end

    def can_see?(point, edge)
      edge.point_to_the_left?(point)
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
