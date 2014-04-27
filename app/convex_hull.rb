require_relative "linked_list"

class ConvexHull

  def initialize(point)
    @root = LinkedList.new(point)
    self_link_root
  end

  def points
    [].tap do |result|
      each_point { |point| result.push(point) }
    end
  end

  def add_point(point)
    insert_point(point, root, root)
  end

  private

    attr_reader :root

    def self_link_root
      root.link_next(root)
      root.link_previous(root)
    end

    def each_point(&block)
      current_node = root

      loop do
        yield(current_node.element)
        current_node = current_node.next_node
        break if current_node == root
      end
    end

    def insert_point(point, p0, p1)
      node = LinkedList.new(point)
      p0.link_next(node)
      p1.link_previous(node)
    end

end
