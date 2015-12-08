require_relative "../../test_helper.rb"
require_relative "../../../app/triangulation/face"
require_relative "../../../app/point"
require_relative "../../../app/dcel/face"

describe Triangulation::Face do

  describe "#contains?" do
    let(:points) { [Point[0, 0], Point[10, 0], Point[0, 10]] }
    let(:graph_face) { DCEL::Face.from_vertices(points) }
    let(:face) { Triangulation::Face.new(graph_face) }

    it "returns true for a point in the interior of the face" do
      point = Point[2, 2]
      face.contains?(point).must_equal(true)
    end

    it "returns false for a point outside of the face" do
      point = Point[100, 100]
      face.contains?(point).must_equal(false)
    end
  end

end
