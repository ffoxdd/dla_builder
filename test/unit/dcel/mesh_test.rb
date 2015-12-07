require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/dcel/builder"

describe DCEL::Mesh do

  describe "#faces, #edges, #vertices" do
    # TODO
  end

  describe ".triangle" do
    it "raises ArgumentError when given fewer than 3 vertices" do
      vertices = 2.times.map { test_vertex }
      proc { DCEL::Builder.triangle(vertices) }.must_raise(ArgumentError)
    end

    it "raises ArgumentError when given more than 3 vertices" do
      vertices = 4.times.map { test_vertex }
      proc { DCEL::Builder.triangle(vertices) }.must_raise(ArgumentError)
    end

    it "creates a mesh with a single triangle" do
      # TODO: consider rewriting this test so you aren't first using the builder and then stubbing it
      vertices = 3.times.map { test_vertex }
      face = DCEL::Builder.triangle(vertices)

      mock_builder = Minitest::Mock.new
      mock_builder.expect(:triangle, face, [vertices])

      DCEL.stub_const(:Builder, mock_builder) do
        mesh = DCEL::Mesh.triangle(vertices)

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

      mesh = DCEL::Mesh.triangle(vertices)
      face = mesh.faces.first

      new_triangles = mesh.subdivide(face, new_vertex)

      mesh.faces.must_equal(new_triangles)
      mesh.edges.size.must_equal(6)
      mesh.vertices.size.must_equal(4)
    end
  end

end
