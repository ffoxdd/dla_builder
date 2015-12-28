module EnumeratorHelpers

  module_function

  def cyclical_pairs_enumerator(enumerable)
    enumerable.cycle.each_cons(2).take(enumerable.size)
  end

  def enumerator_map(enumerator, &transformation)
    Enumerator.new do |y|
      loop { y.yield(transformation.call(enumerator.next)) }
    end
  end

  def enumerator_select(enumerator, &condition)
    Enumerator.new do |y|
      loop do
        enumerator.next.tap { |value| y.yield(value) if condition.call(value) }
      end
    end
  end

  def enumerator_reject(enumerator, &condition)
    Enumerator.new do |y|
      loop do
        enumerator.next.tap { |value| y.yield(value) unless condition.call(value) }
      end
    end
  end

end
