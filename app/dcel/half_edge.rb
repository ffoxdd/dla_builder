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

  attr_reader :origin, :previous_half_edge, :next_half_edge, :twin_half_edge

  def self.degenerate(options = {})
    new(options).tap(&:self_twin!)
  end

  def self_twin!
    self.twin_half_edge = self.class.new(origin: origin, twin_half_edge: self)
  end

  def link_vertex(vertex)
    self.next_half_edge = self.class.degenerate(origin: vertex, previous_half_edge: self)
    twin_half_edge.origin = vertex
    next_half_edge.twin_half_edge.origin = previous_half_edge.origin if previous_half_edge
  end

  protected

  attr_writer :origin, :next_half_edge, :previous_half_edge, :twin_half_edge
  attr_reader :id # utility / for testing

  private

  def inspect_links
    [:previous_half_edge, :next_half_edge, :twin_half_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

end
