class LinkedList

  def initialize(element, previous_node = nil, next_node = nil)
    @element = element
    @previous_node = previous_node
    @next_node = next_node
  end

  def link_next(node)
    self.next_node = node
    node.previous_node = self
  end

  def link_previous(node)
    node.next_node = self
    self.previous_node = node
  end

  attr_reader :element, :previous_node, :next_node

  protected

    attr_writer :previous_node, :next_node

end