require_relative 'edge'
require 'forwardable'

class BoundingBoxFinder

  def initialize(polygon)
    @polygon = polygon
    @calipers = []
    @total_rotation = 0
  end

  def bounding_box
    seed_calipers

    # iterate
    #  - find the smallest angle to an adjacent edge
    #  - move the caliper with that angle along that edge
    #  - rotate the other calipers about their point the given theta

    # stop iterating whent the total rotation amount is > 90 (probably 90.0001 or something?)
  end

  private

    attr_reader :polygon, :calipers
    attr_accessor :total_rotation

    def seed_calipers
      min_x, min_y = polygon.min_nodes
      max_x, max_y = polygon.max_nodes

      calipers << Caliper.new(min_x, Point[0, 1])
      calipers << Caliper.new(max_y, Point[1, 0])
      calipers << Caliper.new(max_x, Point[0, -1])
      calipers << Caliper.new(min_y, Point[-1, 0])
    end

    class Caliper
      extend Forwardable

      def initialize(node, displacement_vector)
        @node = node
        @ray = Ray.new(point, displacement_vector)
      end

      private
        attr_reader :node, :edge
        def_delegators :node, :point

        def adjacent_edge
          node.next_edge
        end
    end

end
