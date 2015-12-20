require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/vertex"
require_relative "../../../app/dcel/cycle_graph_builder"

describe DCEL::Vertex do

  describe "#adjacent_edge_enumerator" do
    let(:vertex_values) { 3.times.map { Object.new }}
    let(:face) { DCEL::CycleGraphBuilder.cycle_graph(vertex_values) }

    it "returns an enumerator for adjacent edges" do
      edges = face.edge_enumerator.to_a
      edge = edges.first

      vertex = edge.origin_vertex
      adjacent_edges = vertex.adjacent_edge_enumerator.to_a

      adjacent_edges.must_cyclically_equal([edges[0], edges[2].opposite_edge])
    end
  end

end
