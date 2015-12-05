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

  def destination_vertex
    next_half_edge.origin
  end

  def adjacent_half_edge
    twin_half_edge.next_half_edge
  end

  def all_adjacent_edges
    enumerator(&:adjacent_half_edge).to_a
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

end
