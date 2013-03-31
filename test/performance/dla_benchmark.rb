require 'rubygems'
gem 'minitest'
require 'minitest/benchmark'
require 'minitest/autorun'

require_relative '../../sketchbook/lib/dla.rb'
require_relative '../../sketchbook/lib/grower.rb'
require_relative '../../sketchbook/lib/particle.rb'

class DlaBenchmark < MiniTest::Unit::TestCase

  def self.bench_range
  	[1, 10, 100, 1000]
  end

  def bench_dla_growth
    assert_performance_power 0.89 do |n|
    	dla = Dla.new
			n.times { dla.grow }
    end
  end

end
