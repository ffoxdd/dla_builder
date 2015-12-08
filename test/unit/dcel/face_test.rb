require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face"
require_relative "../../../app/point"

describe DCEL::Face do

  let(:vertices) do
    3.times.map { test_vertex }
  end

  let(:edges) do
    vertices.map { |vertex| new_edge(vertex) }.tap { |e| cyclically_link(e) }
  end

  def new_edge(vertex)
    DCEL::Edge.new(origin_vertex: vertex)
  end

  def cyclically_link(edges)
    DCEL.cyclical_each_pair(edges) do |previous_edge, next_edge|
      DCEL::Edge.link(previous_edge, next_edge)
    end
  end

  describe ".from_disjoint_edges" do
    # TODO
  end

  describe ".from_connected_edge" do
    # TODO
  end

  describe ".from_vertices" do
    # TODO
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
