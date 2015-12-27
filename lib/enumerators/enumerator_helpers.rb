module EnumeratorHelpers

  def map_enumerator(enumerator, &transformation)
    Enumerator.new do |y|
      loop { y.yield(transformation.call(enumerator.next)) }
    end
  end

end
