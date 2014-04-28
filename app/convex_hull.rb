require_relative "linked_list"

class ConvexHull

  include Enumerable

  def initialize(point)
    @root = LinkedList.new(point)
    self_link_root
  end

  alias_method :points, :to_a

  def each(&block)
    root.tap do |current_node|
      loop do
        yield(current_node.element)
        current_node = current_node.next_node
        return if current_node == root
      end
    end
  end

  def add_point(point)
    if singleton?
      insert_point(point, root, root)
      return
    end

    n0 = lower_tangency_node(point)
    n1 = upper_tangency_node(point)

    return unless n0 && n1
    insert_point(point, n0, n1)
  end

  private

    attr_reader :root

    def singleton?
      root.next_node == root
    end

    def upper_tangency_node(point)
      current_node = root

      loop do
        return current_node if upper_tangency_point?(point, current_node)
        current_node = current_node.next_node
        return if current_node == root
      end
    end

    def lower_tangency_node(point)
      current_node = root

      loop do
        return current_node if lower_tangency_point?(point, current_node)
        current_node = current_node.previous_node
        return if current_node == root
      end
    end

    def upper_tangency_point?(point, node)
      can_see?(point, node.previous_edge) && !can_see?(point, node.next_edge)
    end

    def lower_tangency_point?(point, node)
      !can_see?(point, node.previous_edge) && can_see?(point, node.next_edge)
    end

    def can_see?(point, edge)
      v0 = edge[1] - edge[0]
      v1 = point - edge[0]

      determinant(v0, v1) > 0
    end

    def determinant(v0, v1)
      v0[0] * v1[1] - v0[1] * v1[0]
    end

    def self_link_root
      root.link_next(root)
      root.link_previous(root)
    end

    def insert_point(point, n0, n1)
      node = LinkedList.new(point)
      n0.link_next(node)
      n1.link_previous(node)
    end

end
