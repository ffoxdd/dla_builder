require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face_subdivider"
require_relative "../../../app/dcel/polygon_builder"

describe DCEL::FaceSubdivider do

  describe ".subdivide_face" do
    let(:vertex_values) { 3.times.map { test_vertex }}
    let(:inner_vertex_value) { test_vertex }

    it "subdivides a face about an interior vertex" do
      face = DCEL::PolygonBuilder.polygon(vertex_values)
      perimeter_edges = face.edges

      DCEL::FaceSubdivider.subdivide_face(face, inner_vertex_value) do |new_faces, new_edges, new_vertex|
        inner_faces = perimeter_edges.map(&:left_face)

        inner_faces[0].vertex_values.must_cyclically_equal([vertex_values[0], vertex_values[1], inner_vertex_value])
        inner_faces[1].vertex_values.must_cyclically_equal([vertex_values[1], vertex_values[2], inner_vertex_value])
        inner_faces[2].vertex_values.must_cyclically_equal([vertex_values[2], vertex_values[0], inner_vertex_value])

        new_faces.size.must_equal(3)
        new_edges.size.must_equal(3) # only returns one per side

        new_edges.map(&:left_face).uniq.must_equal(new_faces)

        new_vertex.value.must_equal(inner_vertex_value)

        # new_vertex.adjacent_edges.must_cyclically_equal(new_edges) # THIS IS THE BIG ONE
      end
    end
  end

end
