require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face"
require_relative "../../../app/dcel/vertex"
require_relative "../../../app/point"

describe DCEL::Face do

  let(:vertex_values) do
    3.times.map { test_vertex }
  end

  let(:vertices) do
    vertex_values.map { |value| DCEL::Vertex.new(value) }
  end

  let(:edges) do
    vertices.map { |vertex| DCEL::Edge.new(origin_vertex: vertex) }.tap { |e| cyclically_link(e) }
  end

  def cyclically_link(edges)
    DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
      DCEL::Edge.link(previous_edge, next_edge)
    end
  end

  describe "#opposite_face" do
    # TODO
  end

  describe "#each_edge" do
    # TODO
  end

  describe "#each_vertex" do
    # TODO
  end

  describe "#edges/#vertices/#vertex_values" do
    it "returns the edges that make up the face" do
      face = DCEL::Face.new(edges.first)

      face.edges.must_equal(edges)
      face.vertices.must_equal(vertices)
      face.vertex_values.must_equal(vertex_values)
    end
  end

  describe "#eql?/#hash" do
    def test_face
      DCEL::Face.new(Object.new)
    end

    let(:face) { test_face }
    let(:different_face) { test_face }

    it "only represents equality for identical instances" do
      face.eql?(face).must_equal(true)
      face.eql?(different_face).must_equal(false)

      face.hash.wont_equal(different_face.hash)
    end
  end

end
