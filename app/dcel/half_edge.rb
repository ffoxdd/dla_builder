module DCEL; end

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
    raise ArgumentError unless vertices.size == 3

    half_edges = vertices.map { |vertex| new(origin: vertex) }
    circular_link(half_edges)

    twin_half_edges = half_edges.map { |half_edge| new(origin: half_edge.next_half_edge.origin) }
    circular_link(twin_half_edges.reverse)

    half_edges.zip(twin_half_edges).each do |half_edge, twin_half_edge|
      half_edge.twin_half_edge = twin_half_edge
      twin_half_edge.twin_half_edge = half_edge
    end

    half_edges.first
  end

  def self.circular_link(half_edges)
    cyclical_each_pair(half_edges) do |previous_half_edge, next_half_edge|
      previous_half_edge.next_half_edge = next_half_edge
      next_half_edge.previous_half_edge = previous_half_edge
    end
  end

  def self.cyclical_each_pair(enumerable, &block)
    enumerable.cycle.each_cons(2).take(enumerable.size).each(&block)
  end

  protected

  # attr_writer :origin
  attr_reader :id # utility / for testing

  # def link_next(half_edge)
  #   self.next_half_edge = half_edge
  #   half_edge.previous_half_edge = self
  # end

  # def link_previous(half_edge)
  #   self.previous_half_edge = half_edge
  #   half_edge.next_half_edge = self
  # end
  #
  # def link_twin(half_edge)
  #   self.twin_half_edge = half_edge
  #   half_edge.twin_half_edge = self
  # end

  private

  def inspect_links
    [:previous_half_edge, :next_half_edge, :twin_half_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

end
