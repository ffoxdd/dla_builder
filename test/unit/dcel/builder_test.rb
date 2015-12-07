require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/builder"

describe DCEL::Builder do

  describe ".face" do
    let(:vertices) { 3.times.to_a }

    it "creates a fully linked face" do
      inner_face = DCEL::Builder.polygon(vertices)
      outer_face = inner_face.opposite_face

      inner_face.vertices.must_cyclically_equal(vertices)
      outer_face.vertices.must_cyclically_equal(vertices.reverse)

      inner_face.each_edge { |edge| edge.left_face.must_equal(inner_face) }
      outer_face.each_edge { |edge| edge.left_face.must_equal(outer_face) }
    end
  end

end
