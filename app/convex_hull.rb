require_relative "linked_list"
require_relative "polygon"
require_relative "edge"
require 'forwardable'

class ConvexHull

  extend Forwardable

  def initialize
    @polygon = Polygon.new
  end

  def add_point(point)
    polygon.add_point(point) and return if (empty? || singleton?)
    add_to_hull(point)
  end

  private

    attr_reader :polygon
    attr_accessor :root

    def_delegators :polygon,
      :points, :empty?, :singleton?,
      :find_next, :find_previous, :insert_point

    def add_to_hull(point)
      insert_point(point, lower_tangency_node(point), upper_tangency_node(point))
    end

    def upper_tangency_node(point)
      find_next { |p, node| upper_tangency_point?(point, node) }
    end

    def lower_tangency_node(point)
      find_previous { |p, node| lower_tangency_point?(point, node) }
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

end
