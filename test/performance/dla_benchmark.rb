require 'rubygems'
gem 'minitest'
require 'minitest/benchmark'
require 'minitest/autorun'

require_relative '../../lib/dla.rb'
require_relative '../../lib/grower.rb'
require_relative '../../lib/particle.rb'

class DlaBenchmark < MiniTest::Unit::TestCase

  def self.bench_range
  	# [1, 10, 100]
  	[1, 10, 100, 1000]
  	# [1, 5, 10, 50, 100, 250, 500, 1000]
  	# [1, 10, 100, 250]
  end

  def bench_dla_growth
    assert_performance_power 0.89 do |n|
    	dla = Dla.new
			n.times { dla.grow }
    end
  end

end
