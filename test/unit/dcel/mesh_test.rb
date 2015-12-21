require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/mesh"
require_relative "../../../app/dcel/cycle_graph_builder"
require 'set'

describe DCEL::Mesh do

  describe "#faces, #edges, #vertices" do
    # TODO
  end

  describe ".cycle_graph" do
    let(:vertex_values) { 3.times.map { test_vertex }}

    it "creates a mesh representing a single polygon" do
      mesh = DCEL::Mesh.cycle_graph(vertex_values)

      mesh.faces.size.must_equal(2) # 1 bounded, 1 infinite
      mesh.edges.size.must_equal(3) # only count each polygon edge once
      mesh.vertices.size.must_equal(3)

      mesh.vertex_values.must_cyclically_equal(vertex_values)
    end
  end

  describe "enumerators" do
    let(:points) { 3.times.map { Object.new }}
    let(:new_point) { Object.new }

    before do
      DCEL::Mesh.cycle_graph(points) do |mesh_, face_|
        @mesh = mesh_
        @inner_face = face_
        @invisible_vertex = mesh.vertices.first
        @mesh.subdivide(@inner_face, new_point)
      end
    end

    attr_reader :mesh, :inner_face, :invisible_vertex

    it "enumerates all values, skipping ones marked as invisible" do
      invisible_vertex.invisible!

      mesh.vertex_value_enumerator.to_a.must_equal(points + [new_point] - [invisible_vertex.value])
      mesh.vertex_enumerator.to_a.size.must_equal(3)
      mesh.edge_enumerator.to_a.size.must_equal(3)
      mesh.face_enumerator.to_a.size.must_equal(1)
    end
  end

  describe "#subdivide" do
    let(:vertex_values) { 3.times.map { test_vertex }}
    let(:new_vertex_value) { test_vertex }
    let(:mesh) { DCEL::Mesh.cycle_graph(vertex_values) }
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

end
