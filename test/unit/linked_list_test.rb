require_relative "../test_helper.rb"
require_relative "../../app/linked_list.rb"

describe LinkedList do

  describe "#link_next" do
    it "creates a link to the next node" do
      node_0 = LinkedList.new(nil)
      node_1 = LinkedList.new(nil)

      node_0.link_next(node_1)

      node_0.next_node.must_equal node_1
      node_1.previous_node.must_equal node_0
    end
  end

  describe "#link_previous" do
    it "creates a link to the previous node" do
      node_0 = LinkedList.new(nil)
      node_1 = LinkedList.new(nil)

      node_1.link_previous(node_0)

      node_0.next_node.must_equal node_1
      node_1.previous_node.must_equal node_0
    end
  end

  describe "#next_edge" do
    it "returns a tuple representing the edge after this node" do
      node_0 = LinkedList.new(0)
      node_1 = LinkedList.new(1)
      node_0.link_next(node_1)

      node_0.next_edge.must_equal [0, 1]
    end

    it "returns nil if there is no next node" do
      node = LinkedList.new(nil)
      node.next_edge.must_equal nil
    end
  end

  describe "#previous_edge" do
    it "returns a tuple representing the edge before this node" do
      node_0 = LinkedList.new(0)
      node_1 = LinkedList.new(1)
      node_0.link_next(node_1)

      node_1.previous_edge.must_equal [0, 1]
    end

    it "returns nil if there is no previous node" do
      node = LinkedList.new(nil)
      node.previous_edge.must_equal nil
    end
  end

  # def "#next_enumerator/previous_enumerator" do
  #   it "returns enumerators for the linked list" do
  #   end
  # end
end
