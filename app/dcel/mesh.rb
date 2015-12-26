require_relative "cycle_graph_builder"
require_relative "face_subdivider"
require_relative "quadrilateral_edge_flipper"

module DCEL; end

class DCEL::Mesh

  def initialize(faces:, edges:, vertices:)
    @faces = faces
    @edges = edges
    @vertices = vertices
  end

  def self.cycle_graph(vertex_values)
    DCEL::CycleGraphBuilder.cycle_graph(vertex_values) do |(forward_face, reverse_face), edges, vertices|
      mesh = new(faces: [forward_face, reverse_face], edges: edges, vertices: vertices)
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
    DCEL::FaceSubdivider.subdivide_face(face, new_vertex_value) do |new_faces, new_edges, new_vertex|
      self.faces -= [face]
      self.faces += new_faces
      self.edges += new_edges
      self.vertices += [new_vertex]

      return new_faces
    end
  end

  def flip_quadrilateral_edge(edge)
    DCEL::QuadrilateralEdgeFlipper.flip(edge) do |removed_faces, added_faces, affected_edges|
      self.faces -= removed_faces
      self.faces += added_faces

      yield(affected_edges)
    end
  end

  # private # TODO: check if this can be made private again
  attr_reader :faces, :edges, :vertices

  private
  attr_writer :faces, :edges, :vertices

end
