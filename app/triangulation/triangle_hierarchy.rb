require_relative "hierarchical_triangle"
require_relative "../dcel/mesh"
require_relative "../point"

module Triangulation; end

class Triangulation::TriangleHierarchy

  def initialize
    @mesh = new_boundary_mesh
    @boundary_triangle = boundary_triangle_for(@mesh)
  end

  def points
    boundary_triangle.points - boundary_points
  end

  def add_point(point)
    boundary_triangle.add_point(point)
  end

  private
  attr_reader :mesh, :boundary_triangle

  MAX_VALUE = 10 #1e100 # representing "infinity" in a way that is guaranteed to work (for now)
  # TODO: consider implementing the boundary triangle with a special type

  def new_boundary_mesh
    DCEL::Mesh.polygon(boundary_points)
  end

  def bounded_face(input_mesh)
    input_mesh.faces.find { |dcel_face| Triangulation::Face.from_face(dcel_face).bounded? }
  end

  def boundary_triangle_for(input_mesh)
    Triangulation::HierarchicalTriangle.new(mesh: input_mesh, mesh_face: bounded_face(input_mesh))
  end

  # def face_enumerator(input_mesh)
  #   Enumerator.new do |y|
  #     mesh.faces.each do |dcel_face|
  #       y.yield(Triangulation::Face.new(dcel_face))
  #     end
  #   end
  # end

  def boundary_points
    [Point[MAX_VALUE, MAX_VALUE], Point[-MAX_VALUE, MAX_VALUE], Point[0, -MAX_VALUE]]
  end

end
