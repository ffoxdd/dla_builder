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
    new(options).tap(&:self_link)
  end

  def self_link
    link_all(self)
  end

  def link_vertex(vertex)
    new_half_edge = DCEL::HalfEdge.new(
      origin: vertex,
      previous_half_edge: self,
      next_half_edge: self,
      twin_half_edge: self
    )

    link_all(new_half_edge)
  end

  # def triangle?
  #   next_half_edge.next_half_edge.next_half_edge == self
  # end

  protected

  attr_writer :origin, :next_half_edge, :previous_half_edge, :twin_half_edge
  attr_reader :id # utility / for testing

  private

  def inspect_links
    [:previous_half_edge, :next_half_edge, :twin_half_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

  def link_all(half_edge)
    self.previous_half_edge = half_edge
    self.next_half_edge = half_edge
    self.twin_half_edge = half_edge
  end

end
