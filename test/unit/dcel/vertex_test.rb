require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/vertex"
require_relative "../../../app/dcel/polygon_builder"

describe DCEL::Vertex do

  describe "#adjacent_edges" do
    let(:vertex_values) { 3.times.map { Object.new }}
    let(:face) { DCEL::PolygonBuilder.polygon(vertex_values) }
    let(:vertices) { face.vertices }
    let(:edges) { face.edges }

    it "returns adjacent edges" do
      edge = edges[0]
      vertex = edge.origin_vertex

      vertex.adjacent_edges.must_cyclically_equal([edges[0], edges[2].opposite_edge])
    end
  end

end
