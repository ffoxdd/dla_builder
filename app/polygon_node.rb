require_relative "linked_list"
require_relative "edge"
require "forwardable"

class PolygonNode

  extend Forwardable

  def initialize(options = {})
    raise ArgumentError unless options[:linked_list] || options[:point]
    @linked_list = options.fetch(:linked_list) { LinkedList.new(options[:point]) }

    link_previous(options[:previous_node]) if options[:previous_node]
    link_next(options[:next_node]) if options[:next_node]
  end

  def_delegators :linked_list, :singleton?, :self_link
  def_delegators :point, :[]

  def points
    linked_list.elements
  end

  def point
    linked_list.element
  end

  def previous_node
    PolygonNode.new(linked_list: linked_list.previous_node)
  end

  def next_node
    PolygonNode.new(linked_list: linked_list.next_node)
  end

  def previous_edge
    Edge.new(*linked_list.previous_pair)
  end

  def next_edge
    Edge.new(*linked_list.next_pair)
  end

  def previous_enumerator
    wrap_enumerator(linked_list.previous_enumerator)
  end

  def next_enumerator
    wrap_enumerator(linked_list.next_enumerator)
  end

  protected

    attr_reader :linked_list

  private

    def wrap_enumerator(enumerator)
      Enumerator.new do |yielder|
        loop do
          yielder.yield PolygonNode.new(linked_list: enumerator.next)
        end
      end
    end

    def link_previous(polygon_node)
      linked_list.link_previous(polygon_node.linked_list)
    end

    def link_next(polygon_node)
      linked_list.link_next(polygon_node.linked_list)
    end

end
