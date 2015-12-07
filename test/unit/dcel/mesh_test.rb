require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/dcel/builder"

describe DCEL::Mesh do

  describe "#faces, #edges, #vertices" do
    # TODO
  end

  describe ".polygon" do
    let(:vertices) { 3.times.map { test_vertex }}
    let(:inner_face) { DCEL::Builder.polygon(vertices) }
    let(:mock_builder) { Minitest::Mock.new }

    it "creates a mesh with a single polygon" do
      # TODO: consider rewriting this test so you aren't first using the builder and then stubbing it
      mock_builder.expect(:polygon, inner_face, [vertices])

      DCEL.stub_const(:Builder, mock_builder) do
        mesh = DCEL::Mesh.polygon(vertices)

        mesh.faces.must_equal([inner_face])
        mesh.edges.must_equal(inner_face.edges)
        mesh.vertices.must_equal(inner_face.vertices)
      end

      mock_builder.verify
    end
  end

  describe "#subdivide" do
    it "augments the mesh by subdividing the specified face by a new vertex" do
      vertices = 3.times.map { test_vertex }
      new_vertex = test_vertex

      mesh = DCEL::Mesh.polygon(vertices)
      face = mesh.faces.first

      new_faces = mesh.subdivide(face, new_vertex)

      mesh.faces.must_equal(new_faces)
      mesh.edges.size.must_equal(6)
      mesh.vertices.size.must_equal(4)
    end
  end

  describe "#delete_vertex" do
    let(:vertices) { 3.times.map { test_vertex } }
    let(:inner_vertex) { test_vertex }
    let(:mesh) { DCEL::Mesh.polygon(vertices) }
    let(:face) { mesh.faces.first }

    it "deletes a vertex, along with any incident edges and faces" do
      perimeter_edge = mesh.edges.first
      mesh.subdivide(face, inner_vertex)

      mesh.delete_vertex(perimeter_edge)

      # mesh.faces.size.must_equal(1)
      mesh.edges.size.must_equal(3)
      mesh.vertices.size.must_equal(3)
    end
  end

end
