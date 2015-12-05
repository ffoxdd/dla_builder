require_relative "builder"

module DCEL; end

class DCEL::VertexDeleter
  # So far this "deletes" by reconnecting edges in the mesh to not include the deleted edges.
  # More bookkeeping will need to be done when there is a global list of mesh components.

  def delete_vertex(edge)
    edge.all_adjacent_edges.each { |edge| delete_edge(edge) }
  end

  private

  def delete_edge(edge)
    DCEL::Builder.link_sequentially(*new_corner_edges(edge))
  end

  def new_corner_edges(edge)
    [edge.twin_edge.previous_edge, edge.next_edge]
  end
end
