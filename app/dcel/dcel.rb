module DCEL

  # TODO: find a better place for this helper code
  def cyclical_each_pair(enumerable, &block)
    enumerable.cycle.each_cons(2).take(enumerable.size).each(&block)
  end

  module_function :cyclical_each_pair
end
