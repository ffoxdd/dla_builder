require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face_subdivider"
require_relative "../../../app/dcel/polygon_builder"
require "set"

describe DCEL::FaceSubdivider do

  describe ".subdivide_face" do
    let(:vertex_values) { 3.times.map { test_vertex }}
    let(:inner_vertex_value) { test_vertex }
    let(:face) { DCEL::PolygonBuilder.polygon(vertex_values) }

    attr_reader :perimeter_edges

    before do
      @perimeter_edges = face.edges
    end

    it "subdivides a face about an interior vertex" do
      DCEL::FaceSubdivider.subdivide_face(face, inner_vertex_value) do |new_faces, new_edges, new_vertex|
        new_faces.size.must_equal(3)
        new_edges.size.must_equal(3)

        Set.new(perimeter_edges.map(&:left_face)).must_equal(Set.new(new_faces))

        new_faces.each do |face|
          face.vertices.include?(new_vertex).must_equal(true)
        end

        new_edges.each do |edge|
          new_faces.include?(edge.left_face).must_equal(true)
          edge.vertices.include?(new_vertex).must_equal(true)
        end

        Set.new(new_vertex.adjacent_edges).must_equal(Set.new(new_edges))
        Set.new(new_vertex.adjacent_faces).must_equal(Set.new(new_faces))

        new_vertex.value.must_equal(inner_vertex_value)
      end
    end
  end

end
