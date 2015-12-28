require_relative "dcel"
require_relative "metadata"
require_relative "../../lib/enumerators/enumerator_helpers"

class DCEL::Face

  include DCEL::Metadata
  include EnumeratorHelpers

  def initialize(edge)
    @edge = edge
  end

  def opposite_face
    edge.opposite_edge.left_face
  end

  def edge_enumerator
    edge.next_edge_enumerator
  end

  def vertex_enumerator
    enumerator_map(edge_enumerator, &:origin_vertex)
  end

  def vertex_value_enumerator
    enumerator_map(vertex_enumerator, &:value)
  end

  private
  attr_reader :edge

end
