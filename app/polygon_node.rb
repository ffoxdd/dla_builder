require_relative "linked_list"
require_relative "edge"
require "forwardable"

class PolygonNode

  extend Forwardable

  def self.[](linked_list)
    PolygonNode.new(linked_list: linked_list)
  end

  def initialize(options = {})
    raise ArgumentError unless options[:linked_list] || options[:point]
    @linked_list = options.fetch(:linked_list) { LinkedList.new(options[:point]) }
  end

  def_delegators :linked_list, :singleton?, :self_link

  def previous_enumerator
    wrap_enumerator(linked_list.previous_enumerator)
  end

  def next_enumerator
    wrap_enumerator(linked_list.next_enumerator)
  end

  def previous_edge
    Edge.new(linked_list.previous_pair)
  end

  def next_edge
    Edge.new(linked_list.next_pair)
  end

  def points
    linked_list.elements
  end

  protected

    attr_reader :linked_list

  private

    def wrap_enumerator(enumerator)
      Enumerator.new { |y| loop{ y.yield(PolygonNode[enumerator.next]) }}
    end

    def insert_between(n0, n1)
      linked_list.insert_between(n0.linked_list, n1.linked_list)
    end

    def link_previous(polygon_node)
      linked_list.link_previous(polygon_node.linked_list)
    end

    def link_next(polygon_node)
      linked_list.link_next(polygon_node.linked_list)
    end

end
