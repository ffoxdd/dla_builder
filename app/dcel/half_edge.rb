require_relative "face"
require_relative "builder"

module DCEL
  def self.cyclical_each_pair(enumerable, &block) # TODO: find a better place for this helper code
    enumerable.cycle.each_cons(2).take(enumerable.size).each(&block)
  end
end

class DCEL::HalfEdge

  @@instance_count = 0

  def initialize(options = {})
    @origin = options.fetch(:origin)
    @previous_half_edge = options.fetch(:previous_half_edge, nil)
    @next_half_edge = options.fetch(:next_half_edge, nil)
    @twin_half_edge = options.fetch(:twin_half_edge, nil)

    @id = (@@instance_count += 1)
  end

  def inspect
    "#<#{self.class.name}:#{id} origin=#{origin.to_s} #{inspect_links}>"
  end

  attr_reader :origin
  attr_accessor :previous_half_edge, :next_half_edge, :twin_half_edge

  def next_vertex
    next_half_edge.origin
  end

  def adjacent_half_edge
    twin_half_edge.next_half_edge
  end

  def all_adjacent_edges
    enumerator(&:adjacent_half_edge).to_a
  end

  def subdivide_triangle(inner_vertex)
    Subdivider.new(self, inner_vertex).subdivide_triangle
  end

  def delete_vertex
    VertexDeleter.new.delete_vertex(self)
  end

  def enumerator(&next_procedure)
    Enumerator.new do |y|
      self.tap do |current_half_edge|
        loop do
          y.yield(current_half_edge)
          current_half_edge = next_procedure.call(current_half_edge)
          break if current_half_edge.nil? || current_half_edge == self
        end
      end
    end
  end

  protected
  attr_reader :id # utility

  private

  def inspect_links
    [:previous_half_edge, :next_half_edge, :twin_half_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

  class VertexDeleter
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

  class Subdivider
    def initialize(half_edge, inner_vertex)
      @inner_vertex = inner_vertex
      @original_face_edges = DCEL::Face.new(half_edge).half_edges
    end

    def subdivide_triangle
      build_inner_triangles
      link_spokes
    end

    private
    attr_reader :inner_vertex, :original_face_edges

    def link_spokes
      each_spoke { |inward_edge, outward_edge| DCEL::Builder.link_twin(inward_edge, outward_edge) }
    end

    def build_inner_triangles
      original_face_edges.each { |half_edge| build_inner_triangle(half_edge) }
    end

    def each_spoke
      DCEL.cyclical_each_pair(original_face_edges) do |previous_half_edge, next_half_edge|
        inward_edge = previous_half_edge.next_half_edge
        outward_edge = next_half_edge.previous_half_edge

        yield(inward_edge, outward_edge)
      end
    end

    def build_inner_triangle(perimeter_half_edge)
      inward_edge = DCEL::HalfEdge.new(origin: perimeter_half_edge.next_vertex)
      outward_edge = DCEL::HalfEdge.new(origin: inner_vertex)

      DCEL::Builder.cyclically_link([perimeter_half_edge, inward_edge, outward_edge])
    end
  end

end
