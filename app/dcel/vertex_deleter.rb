require_relative "builder"

module DCEL; end

class DCEL::VertexDeleter
  # So far this "deletes" by reconnecting edges in the mesh to not include the deleted edges.
  # More bookkeeping will need to be done when there is a global list of mesh components.

  def delete_vertex(half_edge)
    half_edge.all_adjacent_edges.each { |half_edge| delete_edge(half_edge) }
  end

  private

  def delete_edge(half_edge)
    DCEL::Builder.link_sequentially(*new_corner_half_edges(half_edge))
  end

  def new_corner_half_edges(half_edge)
    [half_edge.twin_half_edge.previous_half_edge, half_edge.next_half_edge]
  end
end
