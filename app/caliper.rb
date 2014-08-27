require_relative "ray.rb"
require "forwardable"

class Caliper

  extend Forwardable

  def initialize(node, displacement_vector)
    @node = node
    @ray = Ray.new(point, displacement_vector)

    raise ArgumentError unless edge.right_handed?(displacement_vector)
  end

  attr_reader :ray
  def_delegators :node, :point
  alias_method :fulcrum, :point

  def angle
    ray.angle_between(edge)
  end

  def rotate(angle)
    self.ray = ray.rotate(-angle)
    snap_to_edge if approximately_aligned_with_edge?
  end

  def intersection(caliper)
    ray.intersection(caliper.ray)
  end

  private

    attr_accessor :node
    attr_writer :ray
    def_delegators :node, :next_node, :next_edge
    alias_method :edge, :next_edge

    def snap_to_edge
      align_to_edge
      shift_forward
    end

    def align_to_edge
      self.ray = Ray.new(point, edge.to_v)
    end

    def shift_forward
      attach_to_node(next_node)
    end

    def attach_to_node(node)
      self.node = node
      self.ray = Ray.new(node.point, ray.displacement_vector)
    end

    ANGLE_EQUALITY_THRESHOLD = 1e-10

    def approximately_aligned_with_edge?
      ray.angle_between(edge).abs < ANGLE_EQUALITY_THRESHOLD
    end

end
