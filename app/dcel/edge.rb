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

  def self.link(previous_edge, next_edge)
    previous_edge.next_edge = next_edge
    next_edge.previous_edge = previous_edge
  end

  def self.link_opposites(edge, opposite_edge)
    edge.opposite_edge = opposite_edge
    opposite_edge.opposite_edge = edge
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

  def right_face
    opposite_edge.left_face
  end

  def each_adjacent_edge
    enumerator(&:adjacent_edge)
  end

  def each_next_edge
    enumerator(&:next_edge)
  end

  def each_adjacent_face
    enumerator(:left_face, &:adjacent_edge)
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

  def enumerator(value_proc = :itself, &next_proc)
    value_proc = value_proc.to_proc

    original_value = value_proc.call(self)
    current_edge = self
    current_value = value_proc.call(current_edge)

    Enumerator.new do |y|
      loop do
        y.yield(current_value)

        current_edge = next_proc.call(current_edge)
        current_value = value_proc.call(current_edge)

        break if current_value.nil? || current_value == original_value
      end
    end
  end

  private

  def inspect_links
    [:previous_edge, :next_edge, :opposite_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

end
