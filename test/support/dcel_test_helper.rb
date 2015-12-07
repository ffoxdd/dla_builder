require_relative "../../app/dcel/edge"
require_relative "../../app/dcel/face"

def test_vertex
  Object.new
end

def test_edge
  DCEL::Edge.new(origin_vertex: test_vertex)
end
