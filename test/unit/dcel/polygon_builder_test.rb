require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/polygon_builder"

describe DCEL::PolygonBuilder do

  describe ".face" do
    let(:input_vertices) { 3.times.map { test_vertex }}

    it "yields a fully linked face" do
      block_reached = false

      DCEL::PolygonBuilder.polygon(input_vertices) do |faces, edges, vertices|
        block_reached = true

        faces.size.must_equal(2)
        edges.size.must_equal(3)
        vertices.must_cyclically_equal(input_vertices)

        inner_face, outer_face = faces

        inner_face.vertices.must_cyclically_equal(vertices)
        outer_face.vertices.must_cyclically_equal(vertices.reverse)

        inner_face.opposite_face.must_equal(outer_face)
        outer_face.opposite_face.must_equal(inner_face)

        edges.map(&:origin_vertex).must_cyclically_equal(vertices)
      end

      block_reached.must_equal(true)
    end
  end

end
