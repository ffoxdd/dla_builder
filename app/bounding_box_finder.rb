require_relative 'edge'

class BoundingBoxFinder

  def initialize(polygon)
    @polygon = polygon
    @calipers = []
    @total_rotation = 0
  end

  def bounding_box
    seed_calipers(*polygon.extreme_nodes)

    # iterate
    #  - find the smallest angle to an adjacent edge
    #  - move the caliper with that angle along that edge
    #  - rotate the other calipers about their point the given theta

    # stop iterating whent the total rotation amount is > 90 (probably 90.0001 or something?)
  end

  private

    attr_reader :polygon, :calipers
    attr_accessor :total_rotation

    def seed_calipers((min_x, max_x), (min_y, max_y))
      calipers << Caliper.new(min_x, Point[0, 1])
      calipers << Caliper.new(max_x, Point[0, -1])
      calipers << Caliper.new(min_y, Point[-1, 0])
      calipers << Caliper.new(max_y, Point[1, 0])
    end

    class Caliper
      def initialize(node, displacement_vector)
        @node = node
        @edge = new_edge(displacement_vector)
      end

      private
        def point
          node.element
        end

        def adjacent_edge
          node.next_edge
        end

        def new_edge(displacement_vector)
          Edge[point, point + displacement_vector]
        end
    end

end
