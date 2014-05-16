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

  describe "#next_pair" do
    it "returns a tuple representing the edge after this node" do
      node_0 = LinkedList.new(0)
      node_1 = LinkedList.new(1)
      node_0.link_next(node_1)

      node_0.next_pair.must_equal [0, 1]
    end

    it "returns nil if there is no next node" do
      node = LinkedList.new(nil)
      node.next_pair.must_equal nil
    end
  end

  describe "#previous_pair" do
    it "returns a tuple representing the edge before this node" do
      node_0 = LinkedList.new(0)
      node_1 = LinkedList.new(1)
      node_0.link_next(node_1)

      node_1.previous_pair.must_equal [0, 1]
    end

    it "returns nil if there is no previous node" do
      node = LinkedList.new(nil)
      node.previous_pair.must_equal nil
    end
  end

  describe "#self_link" do
    it "links a node to itself" do
      node = LinkedList.new(nil)
      node.self_link

      node.previous_node.must_equal node
      node.next_node.must_equal node
    end
  end

  describe "#singleton?" do
    it "returns true for an unlinked node" do
      LinkedList.new(nil).singleton?.must_equal true
    end

    it "returns true for a self-linked node" do
      node = LinkedList.new(nil)
      node.self_link

      node.singleton?.must_equal true
    end

    it "returns false for a multi-node list" do
      node_1 = LinkedList.new(nil)
      node_2 = LinkedList.new(nil)
      node_1.link_next(node_2)

      node_1.singleton?.must_equal false
    end
  end

  describe "#insert_between" do
    it "inserts the node between two other nodes" do
      node = LinkedList.new(nil)
      new_previous_node = LinkedList.new(nil)
      new_next_node = LinkedList.new(nil)
      node.insert_between(new_previous_node, new_next_node)

      node.previous_node.must_equal new_previous_node
      node.next_node.must_equal new_next_node
    end
  end

  describe "#elements" do
    it "returns all elements" do
      node_0 = LinkedList.new(0)
      node_1 = LinkedList.new(1)
      node_0.link_next(node_1)

      node_0.elements.must_cyclically_equal [0, 1]
    end
  end

  # def "#next_enumerator/previous_enumerator" do
  #   it "returns enumerators for the linked list" do
  #   end
  # end
end
