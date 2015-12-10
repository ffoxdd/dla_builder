require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/polygon_builder"

describe DCEL::PolygonBuilder do

  describe ".face" do
    let(:vertex_values) { 3.times.map { test_vertex }}

    it "yields a fully linked face" do
      block_reached = false

      DCEL::PolygonBuilder.polygon(vertex_values) do |faces, edges, vertices|
        block_reached = true

        faces.size.must_equal(2)
        edges.size.must_equal(3)
        vertices.map(&:value).must_cyclically_equal(vertex_values)

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
