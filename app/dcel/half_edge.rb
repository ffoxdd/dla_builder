module DCEL; end

class DCEL::HalfEdge

  def initialize(options = {})
    @origin = options.fetch(:origin)
    @previous_half_edge = options.fetch(:previous_half_edge, nil)
    @next_half_edge = options.fetch(:next_half_edge, nil)
    @twin_half_edge = options.fetch(:twin_half_edge, nil)
  end

  attr_reader :origin, :previous_half_edge, :next_half_edge, :twin_half_edge

  def link_next(new_half_edge)
    self.next_half_edge.previous_half_edge = nil if next_half_edge
    self.next_half_edge = new_half_edge
    twin_half_edge.origin = new_half_edge.origin if twin_half_edge
    new_half_edge.previous_half_edge = self
  end

  def link_previous(new_half_edge)
    previous_half_edge.next_half_edge = nil if previous_half_edge
    self.previous_half_edge = new_half_edge
    new_half_edge.twin_half_edge.origin = origin if new_half_edge.twin_half_edge
    new_half_edge.next_half_edge = self
  end

  def link_twin(twin_half_edge)
    self.twin_half_edge = twin_half_edge
    twin_half_edge.twin_half_edge = self if twin_half_edge
  end

  def triangle?
    each_face_half_edge.to_a.size == 3
  end

  # def each_perimeter
  #   Enumerator.new do |y|
  #     self.tap do |current_half_edge|
  #       loop do
  #         y << current_half_edge
  #         current_half_edge = current_half_edge.next_half_edge
  #         break if current_half_edge.nil? || current_half_edge == self
  #       end
  #     end
  #   end
  # end

  protected

  def each_face_half_edge
    Enumerator.new do |y|
      self.tap do |current_half_edge|
        loop do
          y << current_half_edge
          current_half_edge = current_half_edge.next_half_edge
          break if current_half_edge.nil? || current_half_edge == self
        end
      end
    end
  end



  attr_writer :origin, :next_half_edge, :previous_half_edge, :twin_half_edge

end
