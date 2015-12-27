require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/face"
require_relative "../../../app/point"
require_relative "../../../app/dcel/vertex"
require_relative "../../../app/dcel/cycle_graph_builder"

describe Triangulation::Face do

  let(:vertices) { points.map { |p| DCEL::Vertex.new() }}
  let(:graph_face) { DCEL::CycleGraphBuilder.cycle_graph(points) }
  let(:face) { Triangulation::Face.new(graph_face) }

  describe "#points" do
    let(:points) { [Point[0, 0], Point[10, 0], Point[0, 10]] }

    it "returns the points for the face" do
      face.points.must_equal(points)
    end
  end

  describe "#contains?" do
    let(:points) { [Point[0, 0], Point[10, 0], Point[0, 10]] }

    it "returns true for a point in the interior of the face" do
      point = Point[2, 2]
      face.contains?(point).must_equal(true)
    end

    it "returns false for a point outside of the face" do
      point = Point[100, 100]
      face.contains?(point).must_equal(false)
    end
  end

  describe "#bounded?" do
    describe "for right-handed points" do
      let(:points) { [Point[0, 0], Point[1, 0], Point[0, 1]] }

      it "is true" do
        face.bounded?.must_equal(true)
      end
    end

    describe "for left-handed points" do
      let(:points) { [Point[0, 0], Point[1, 0], Point[0, 1]].reverse }

      it "is false for a face with left-handed orientation" do
        face.bounded?.must_equal(false)
      end
    end
  end

  describe "#circumcircle_contains?" do
    let(:points) { [Point[-1, 0], Point[1, 0], Point[0, 1]] }

    def vertex(*coordinates)
      DCEL::Vertex.new(Point.new(coordinates))
    end

    specify { face.circumcircle_contains?(vertex(0, -0.5)).must_equal(true) }
    specify { face.circumcircle_contains?(vertex(0, -1.5)).must_equal(false) }

    specify { face.circumcircle_contains?(vertex(0, -1.0)).must_equal(true) } # include boundary points
    specify { face.circumcircle_contains?(vertex(0, -1.0 - 1e-15)).must_equal(false) }
    specify { face.circumcircle_contains?(vertex(-1, 0)).must_equal(true) }
    specify { face.circumcircle_contains?(vertex(1e100, 1e100)).must_equal(false) }
    specify { face.circumcircle_contains?(vertex(1e100, -1e100)).must_equal(false) }
  end

end
