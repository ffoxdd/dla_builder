require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face"

describe DCEL::Face do

  let(:vertices) do
    3.times.map { test_vertex }
  end

  let(:edges) do
    vertices.map { |vertex| DCEL::Edge.new(origin_vertex: vertex) }.tap do |_edges|
      DCEL::Builder.cyclically_link(_edges)
    end
  end

  describe "#edges" do
    it "returns the edges that make up the face" do
      face = DCEL::Face.new(edges.first)
      face.edges.must_equal(edges)
    end
  end

  describe "#vertices" do
    it "returns the vertices that make up the face" do
      face = DCEL::Face.new(edges.first)
      face.vertices.must_equal(vertices)
    end
  end

end
