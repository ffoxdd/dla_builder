require_relative "dcel"
require_relative "manipulation/cycle_graph_builder"
require_relative "manipulation/face_subdivider"
require_relative "manipulation/quadrilateral_edge_flipper"

class DCEL::Mesh

  def initialize(mesh_update = DCEL::Manipulation::MeshUpdate.new)
    @faces = []
    @edges = []
    @vertices = []

    update(mesh_update)
  end

  def self.cycle_graph(vertex_values)
    DCEL::Manipulation::CycleGraphBuilder.cycle_graph(vertex_values) do |mesh_update, forward_face|
      mesh = new(mesh_update)
      yield(mesh, forward_face) if block_given?
      return mesh
    end
  end

  attr_reader :faces, :edges, :vertices

  def face_enumerator
    faces.lazy
  end

  def edge_enumerator
    edges.lazy
  end

  def vertex_enumerator
    vertices.lazy
  end

  def vertex_value_enumerator
    vertex_enumerator.map(&:value)
  end

  def vertex_values
    vertex_value_enumerator.to_a
  end

  def subdivide(face, new_vertex_value)
    DCEL::Manipulation::FaceSubdivider.subdivide_face(face, new_vertex_value) do |mesh_update|
      update(mesh_update)
      return mesh_update.added_faces
    end
  end

  def flip_quadrilateral_edge(edge)
    DCEL::Manipulation::QuadrilateralEdgeFlipper.flip(edge) do |mesh_update, affected_edges|
      update(mesh_update)
      yield(affected_edges)
    end
  end

  # private # TODO: check if this can be made private again
  attr_reader :faces, :edges, :vertices

  private
  attr_writer :faces, :edges, :vertices

  def update(mesh_update)
    self.vertices += mesh_update.added_vertices
    self.vertices -= mesh_update.removed_vertices
    self.edges += mesh_update.added_edges
    self.edges -= mesh_update.removed_edges
    self.faces += mesh_update.added_faces
    self.faces -= mesh_update.removed_faces
  end

end
