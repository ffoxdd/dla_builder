require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/dcel/builder"

describe DCEL::Mesh do

  describe "#faces, #edges, #vertices" do
    # TODO
  end

  describe ".face" do
    let(:vertices) { 3.times.map { test_vertex }}
    let(:face) { DCEL::Builder.face(vertices) }
    let(:mock_builder) { Minitest::Mock.new }

    it "creates a mesh with a single face" do
      # TODO: consider rewriting this test so you aren't first using the builder and then stubbing it
      mock_builder.expect(:face, face, [vertices])

      DCEL.stub_const(:Builder, mock_builder) do
        mesh = DCEL::Mesh.face(vertices)

        mesh.faces.must_equal([face])
        mesh.edges.must_equal(face.edges)
        mesh.vertices.must_equal(face.vertices)
      end

      mock_builder.verify
    end
  end

  describe "#subdivide" do
    it "augments the mesh by subdividing the specified face by a new vertex" do
      vertices = 3.times.map { test_vertex }
      new_vertex = test_vertex

      mesh = DCEL::Mesh.face(vertices)
      face = mesh.faces.first

      new_faces = mesh.subdivide(face, new_vertex)

      mesh.faces.must_equal(new_faces)
      mesh.edges.size.must_equal(6)
      mesh.vertices.size.must_equal(4)
    end
  end

end
