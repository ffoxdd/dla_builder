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

end
