require_relative "../test_helper.rb"
require_relative "../../app/caliper.rb"
require_relative "../../app/polygon_node.rb"

def test_node(x, y, options = {})
  PolygonNode.new(options.merge(point: Vector2D[x, y]))
end

describe Caliper do

  let(:node) { test_node(0, 0, next_node: test_node(1, 0)) }

  describe "#initialize" do
    it "requires the displacement vector to be in the positive direction relative to the edge" do
      proc { Caliper.new(node, Vector2D[0, -1]) }.must_raise ArgumentError
    end
  end

  describe "#angle" do
    it "returns the angle from the caliper to its edge" do
      caliper = Caliper.new(node, Vector2D[0, 1])
      caliper.angle.must_equal Math::PI / 2
    end
  end

  describe "#rotate" do
    it "simply rotates the caliper about the fulcrum when it moves partway towards its edge" do
      caliper = Caliper.new(node, Vector2D[0, 1])
      caliper.rotate(Math::PI / 4)

      caliper.angle.must_be_close_to Math::PI / 4, 1e-10
      caliper.fulcrum.must_equal Vector2D[0, 0]
    end

    it "moves the fulcrom forward if rotated onto its edge" do
      caliper = Caliper.new(node, Vector2D[0, 1])
      caliper.rotate(Math::PI / 2)

      caliper.fulcrum.must_equal Vector2D[1, 0]
    end

    it "also moves the fulcrum forward if rotated very close to its edge" do
      caliper = Caliper.new(node, Vector2D[0, 1])
      caliper.rotate((Math::PI/2) - 1e-13)

      caliper.fulcrum.must_equal Vector2D[1, 0]
    end
  end

  describe "#intersection" do
    let(:node_1) { test_node(0, 0, next_node: test_node(1, 0)) }
    let(:node_2) { test_node(-1, -1, next_node: test_node(-2, -1)) }

    it "returns the intersection point between two calipers" do
      caliper_1 = Caliper.new(node_1, Vector2D[0, 1])
      caliper_2 = Caliper.new(node_2, Vector2D[1, 0])

      caliper_1.intersection(caliper_2).must_equal Vector2D[0, -1]
    end
  end

end
