require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face_subdivider"
require_relative "../../../app/dcel/polygon_builder"

def test_vertex
  Object.new
end

describe DCEL::FaceSubdivider do

  describe ".subdivide_face" do
    let(:vertices) { 3.times.map { test_vertex }}
    let(:inner_vertex) { test_vertex }

    it "subdivides a face about an interior vertex" do
      face = DCEL::PolygonBuilder.polygon(vertices)
      perimeter_edges = face.edges

      DCEL::FaceSubdivider.subdivide_face(face, inner_vertex) do |new_faces, new_edges|
        inner_faces = perimeter_edges.map(&:left_face)

        inner_faces[0].vertices.must_cyclically_equal([vertices[0], vertices[1], inner_vertex])
        inner_faces[1].vertices.must_cyclically_equal([vertices[1], vertices[2], inner_vertex])
        inner_faces[2].vertices.must_cyclically_equal([vertices[2], vertices[0], inner_vertex])

        new_faces.size.must_equal(3)
        new_edges.size.must_equal(3) # only returns one per side

        new_edges.map(&:left_face).uniq.must_equal(new_faces)
      end
    end
  end

end
