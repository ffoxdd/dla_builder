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
    "#<#{self.class.name}:#{id} origin=#{origin.object_id} #{inspect_links}>"
  end

  attr_reader :origin
  attr_accessor :previous_half_edge, :next_half_edge, :twin_half_edge

  def self.triangle(vertices)
    Builder.triangle(vertices)
  end

  def next_vertex
    return unless next_half_edge
    next_half_edge.origin
  end

  class Builder
    def self.triangle(vertices)
      new.triangle(vertices)
    end

    def triangle(vertices)
      raise ArgumentError unless vertices.size == 3

      half_edges = vertices.map { |vertex| new_half_edge(vertex) }
      circular_link(half_edges)

      twin_half_edges = half_edges.map { |half_edge| new_half_edge(half_edge.next_vertex) }
      circular_link(twin_half_edges.reverse)

      link_twins(half_edges, twin_half_edges)

      half_edges.first
    end

    private

    def new_half_edge(vertex)
      DCEL::HalfEdge.new(origin: vertex)
    end

    def link_twins(half_edges, twin_half_edges)
      half_edges.zip(twin_half_edges).each do |half_edge, twin_half_edge|
        link_twin(half_edge, twin_half_edge)
      end
    end

    def circular_link(half_edges)
      DCEL.cyclical_each_pair(half_edges) do |previous_half_edge, next_half_edge|
        link_sequentially(previous_half_edge, next_half_edge)
      end
    end

    def link_sequentially(previous_half_edge, next_half_edge)
      previous_half_edge.next_half_edge = next_half_edge
      next_half_edge.previous_half_edge = previous_half_edge
    end

    def link_twin(half_edge, twin_half_edge)
      half_edge.twin_half_edge = twin_half_edge
      twin_half_edge.twin_half_edge = half_edge
    end
  end

  protected

  # attr_writer :origin
  attr_reader :id # utility

  private

  def inspect_links
    [:previous_half_edge, :next_half_edge, :twin_half_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

end
