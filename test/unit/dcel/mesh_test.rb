require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/dcel/polygon_builder"
require 'set'

describe DCEL::Mesh do

  describe "#faces, #edges, #vertices" do
    # TODO
  end

  describe ".polygon" do
    let(:vertex_values) { 3.times.map { test_vertex }}

    it "creates a mesh representing a single polygon" do
      mesh = DCEL::Mesh.polygon(vertex_values)

      mesh.faces.size.must_equal(2) # 1 bounded, 1 infinite
      mesh.edges.size.must_equal(3) # only count each polygon edge once
      mesh.vertices.size.must_equal(3)

      mesh.vertex_values.must_cyclically_equal(vertex_values)
    end
  end

  describe "#subdivide" do
    let(:vertex_values) { 3.times.map { test_vertex }}
    let(:new_vertex_value) { test_vertex }
    let(:mesh) { DCEL::Mesh.polygon(vertex_values) }
    let(:face) { mesh.faces.first }

    it "augments the mesh by subdividing the specified face by a new vertex" do
      mesh.subdivide(face, new_vertex_value)

      mesh.faces.size.must_equal(4) # 3 bounded, 1 infinite
      mesh.edges.size.must_equal(6)
      mesh.vertices.size.must_equal(4)

      new_vertex_values = vertex_values + [new_vertex_value]
      Set.new(mesh.vertex_values).must_equal(Set.new(new_vertex_values))
    end
  end

  describe "#delete_vertex" do
    let(:perimeter_vertex_values) { 3.times.map { test_vertex } }
    let(:inner_vertex_value) { test_vertex }
    let(:vertex_values) { perimeter_vertex_values + [inner_vertex_value] }
    let(:mesh) { DCEL::Mesh.polygon(perimeter_vertex_values) }
    let(:face) { mesh.faces.first }

    attr_reader :perimeter_edge, :deleted_vertex

    before do
      @perimeter_edge = mesh.edges.first
      @deleted_vertex = @perimeter_edge.origin_vertex
      mesh.subdivide(face, inner_vertex_value)
    end

    it "deletes a vertex, along with any incident edges and faces" do
      mesh.delete_vertex(perimeter_edge)

      mesh.faces.size.must_equal(2) # 1 bounded, 1 infinite
      mesh.edges.size.must_equal(3)
      mesh.vertices.size.must_equal(3)

      remaining_vertex_values = vertex_values - [deleted_vertex.value]
      Set.new(mesh.vertex_values).must_equal(Set.new(remaining_vertex_values))
    end
  end

end
