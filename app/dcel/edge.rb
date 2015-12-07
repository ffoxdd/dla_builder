module DCEL
  def self.cyclical_each_pair(enumerable, &block) # TODO: find a better place for this helper code
    enumerable.cycle.each_cons(2).take(enumerable.size).each(&block)
  end
end

class DCEL::Edge

  @@instance_count = 0

  def initialize(options = {})
    @origin_vertex = options.fetch(:origin_vertex)
    @previous_edge = options.fetch(:previous_edge, nil)
    @next_edge = options.fetch(:next_edge, nil)
    @opposite_edge = options.fetch(:opposite_edge, nil)
    @left_face = options.fetch(:left_face, nil)

    @id = (@@instance_count += 1)
  end

  def inspect
    "#<#{self.class.name}:#{id} origin_vertex=#{origin_vertex.to_s} #{inspect_links}>"
  end

  attr_reader :origin_vertex
  attr_accessor :previous_edge, :next_edge, :opposite_edge, :left_face

  def destination_vertex
    next_edge.origin_vertex
  end

  def adjacent_edge
    opposite_edge.next_edge
  end

  def all_adjacent_edges
    enumerator(&:adjacent_edge).to_a
  end

  def right_face
    opposite_edge.left_face
  end

  def enumerator(&next_procedure)
    Enumerator.new do |y|
      self.tap do |current_edge|
        loop do
          y.yield(current_edge)
          current_edge = next_procedure.call(current_edge)
          break if current_edge.nil? || current_edge == self
        end
      end
    end
  end

  def eql?(edge)
    vertices == edge.vertices
  end

  def hash
    vertices.hash
  end

  protected
  attr_reader :id # utility

  def vertices
    [origin_vertex, destination_vertex]
  end

  private

  def inspect_links
    [:previous_edge, :next_edge, :opposite_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

end
