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
    polygon.add_point(point) and return if degenerate?
    add_to_hull(point)
  end

  private

    attr_reader :polygon
    def_delegators :polygon, :points, :degenerate?, :find_next, :find_previous, :insert_point

    def add_to_hull(point)
      lower_node, upper_node = lower_tangency_node(point), upper_tangency_node(point)
      return unless lower_node && upper_node

      insert_point(point, lower_node, upper_node)
    end

    def upper_tangency_node(point)
      find_next do |test_point, previous_edge, next_edge|
        upper_tangency_point?(point, previous_edge, next_edge)
      end
    end

    def lower_tangency_node(point)
      find_previous do |test_point, previous_edge, next_edge|
        lower_tangency_point?(point, previous_edge, next_edge)
      end
    end

    def upper_tangency_point?(point, previous_edge, next_edge)
      can_see?(point, previous_edge) && !can_see?(point, next_edge)
    end

    def lower_tangency_point?(point, previous_edge, next_edge)
      !can_see?(point, previous_edge) && can_see?(point, next_edge)
    end

    def can_see?(point, edge)
      edge.point_to_the_left?(point)
    end

end
