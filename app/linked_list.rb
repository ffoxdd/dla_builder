class LinkedList

  def initialize(element, previous_node = nil, next_node = nil)
    @element = element
    @previous_node = previous_node
    @next_node = next_node
  end

  attr_reader :element, :previous_node, :next_node

  def link_next(node)
    self.next_node = node
    node.previous_node = self
  end

  def link_previous(node)
    node.next_node = self
    self.previous_node = node
  end

  def next_pair
    return unless next_node
    [element, next_node.element]
  end

  def previous_pair
    return unless previous_node
    [previous_node.element, element]
  end

  def next_enumerator
    enumerator(&:next_node)
  end

  def previous_enumerator
    enumerator(&:previous_node)
  end

  def self_link
    link_next(self)
  end

  def singleton?
    return true if unlinked?
    next_node == self
  end

  def elements
    next_enumerator.map(&:element)
  end

  protected

    attr_writer :previous_node, :next_node

    def enumerator(&iterator)
      Enumerator.new do |y|
        self.tap do |current_node|
          loop do
            y.yield(current_node)
            current_node = iterator.call(current_node)
            break if current_node.nil? || current_node == self
          end
        end
      end
    end

    def unlinked?
      !previous_node && !next_node
    end

end
