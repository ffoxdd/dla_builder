require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

MiniTest::Spec.class_eval do
  def self.shared_examples
    @shared_examples ||= {}
  end
end

def shared_examples_for(desc, &block)
  MiniTest::Spec.shared_examples[desc] = block
end

def it_behaves_like(desc, &block)
  describe desc do
    instance_eval &MiniTest::Spec.shared_examples[desc]
    instance_eval &block if block_given?
  end
end

module MiniTest::Assertions
  def assert_cyclically_equal(a1, a2)
    assert cyclically_equal?(a1, a2), "Expected #{a1} to be cyclically equal to #{a2}"
  end

  private
    def cyclically_equal?(a0, a1)
      cyclic_permutations(a0).any? { |a| a == a1 }
    end

    def cyclic_permutations(array)
      array.size.times.map { array.unshift(array.pop).dup }
    end
end

Array.infect_an_assertion :assert_cyclically_equal, :must_cyclically_equal
