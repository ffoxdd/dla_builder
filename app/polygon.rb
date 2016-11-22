require_relative "linked_list"
require_relative "polygon_node"
require_relative "edge"
require_relative "axis_aligned_bounding_box"
require_relative "bounding_box_finder"
require "memoist"

class Polygon

  extend Memoist

  def initialize(*points)
    @minmax = [[], []]
    points.each { |point| add_point(point) }
  end

  def add_point(point)
    seed(point) and return if empty?
    add_to_end(point)
  end

  def insert_point(point, n0, n1)
    self.root = new_vertex(point, previous_node: n0, next_node: n1)
  end

  def points
    return [] if empty?
    root.points
  end

  def degenerate?
    empty? || singleton?
  end

  def find_previous(&block)
    return if empty?
    root.previous_enumerator.find(&block)
  end

  def find_next(&block)
    return if empty?
    root.next_enumerator.find(&block)
  end

  attr_reader :minmax

  def empty?
    !root
  end

  def singleton?
    return false if empty?
    root.singleton?
  end

  def bounding_box
    BoundingBoxFinder.new(self).bounding_box
  end

  def axis_aligned_bounding_box
    AxisAlignedBoundingBox.new(*minmax_ranges)
  end

  memoize :bounding_box, :axis_aligned_bounding_box

  private

  attr_accessor :root
  attr_writer :minmax

  def add_to_end(point)
    old_end = root.previous_node
    new_vertex(point, previous_node: old_end, next_node: root)
  end

  def seed(point)
    self.root = new_vertex(point)
    root.self_link
  end

  def new_vertex(point, attributes = {})
    PolygonNode.new(attributes.merge(point: point)).tap { |node| update_minmax(node) }
  end

  def update_minmax(new_node)
    self.minmax = minmax.map.with_index do |sub_minmax, dimension|
      sub_minmax.push(new_node).minmax_by { |node| node[dimension] }
    end

    flush_cache
  end

  def minmax_ranges
    minmax.map.with_index do |sub_minmax, dimension|
      sub_minmax.map { |vertex| vertex[dimension] }
    end
  end

  def last_node
    root.previous_node
  end

end
