require_relative "linked_list"
require_relative "edge"

class Polygon

  def add_point(point)
    seed(point) and return if empty?
    insert_point(point, root.previous_node, root)
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
    next_enumerator.find { |node| yield(node.element, previous_edge(node), next_edge(node)) }
  end

  alias_method :find, :find_next

  def insert_point(point, n0, n1)
    insert_node(LinkedList.new(point), n0, n1)
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

end
