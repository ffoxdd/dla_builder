require_relative "../../../test_helper.rb"
require_relative "../../../support/dcel_test_helper.rb"
require_relative "../../../../app/dcel/manipulation/cycle_graph_builder"
require "set"

describe DCEL::Manipulation::CycleGraphBuilder do

  describe ".cycle_graph" do
    let(:vertex_values) { 3.times.map { test_vertex }}

    it "yields a fully linked face" do
      block_reached = false

      DCEL::Manipulation::CycleGraphBuilder.cycle_graph(vertex_values) do |faces, edges, vertices|
        block_reached = true

        faces.size.must_equal(2)
        edges.size.must_equal(3)
        vertices.size.must_equal(3)

        inner_face, outer_face = faces

        inner_face.vertex_enumerator.to_a.must_cyclically_equal(vertices)
        outer_face.vertex_enumerator.to_a.must_cyclically_equal(vertices.reverse)

        inner_face.opposite_face.must_equal(outer_face)
        outer_face.opposite_face.must_equal(inner_face)

        edges.each do |edge|
          Set.new([edge.left_face, edge.right_face]).must_equal(Set.new(faces))
          vertices.include?(edge.origin_vertex).must_equal(true)
        end

        vertices.each do |vertex|
          other_vertices = vertices - [vertex]
          adjacent_origin_vertices = vertex.adjacent_edge_enumerator.map(&:origin_vertex)
          adjacent_destination_vertices = vertex.adjacent_edge_enumerator.map(&:destination_vertex)

          Set.new(adjacent_origin_vertices).must_equal(Set.new([vertex]))
          Set.new(adjacent_destination_vertices).must_equal(Set.new(other_vertices))
        end

        Set.new(vertices.map(&:value)).must_equal(Set.new(vertex_values))
      end

      block_reached.must_equal(true)
    end
  end

end
