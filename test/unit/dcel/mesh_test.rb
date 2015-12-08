require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/dcel/polygon_builder"

describe DCEL::Mesh do

  describe "#faces, #edges, #vertices" do
    # TODO
  end

  describe ".polygon" do
    let(:vertices) { 3.times.map { test_vertex }}

    it "creates a mesh representing a single polygon" do
      mesh = DCEL::Mesh.polygon(vertices)

      # mesh.faces.size.must_equal(2) # 1 bounded, 1 infinite
      mesh.edges.size.must_equal(3) # only count each polygon edge once
      mesh.vertices.must_cyclically_equal(vertices)
    end
  end

  describe "#subdivide" do
    let(:vertices) { 3.times.map { test_vertex }}
    let(:new_vertex) { test_vertex }
    let(:mesh) { DCEL::Mesh.polygon(vertices) }
    let(:face) { mesh.faces.first }

    it "augments the mesh by subdividing the specified face by a new vertex" do
      mesh.subdivide(face, new_vertex)

      # mesh.faces.size.must_equal(4) # 3 bounded, 1 infinite
      mesh.edges.size.must_equal(6)
      mesh.vertices.size.must_equal(4)
    end
  end

  describe "#delete_vertex" do
    let(:vertices) { 3.times.map { test_vertex } }
    let(:inner_vertex) { test_vertex }
    let(:mesh) { DCEL::Mesh.polygon(vertices) }
    let(:face) { mesh.faces.first }

    attr_reader :perimeter_edge

    before do
      @perimeter_edge = mesh.edges.first
      mesh.subdivide(face, inner_vertex)
    end

    it "deletes a vertex, along with any incident edges and faces" do
      mesh.delete_vertex(perimeter_edge)

      # mesh.faces.size.must_equal(2) # 1 bounded, 1 infinite
      mesh.edges.size.must_equal(3)
      mesh.vertices.size.must_equal(3)
    end
  end

end
