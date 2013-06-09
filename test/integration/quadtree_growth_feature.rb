require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative '../../sketchbook/lib/dla.rb'
require_relative '../../sketchbook/lib/quadtree.rb'
require_relative '../../sketchbook/lib/quadtree_grower.rb'

describe "Quadtree DLA Growth" do

  let(:seed) { [Particle.new(0, 0, 2)] }
  # let(:renderer) { MiniTest::Mock.new }
  let(:quadtree) { Quadtree.new(-1000..1000, -1000..1000) }

  let(:dla) do
  	Dla.new :particles => quadtree, :grower_source => QuadtreeGrower,
  	 :seeds => seed, :radius => 2.0, :overlap => 0.5
  end

  it "does not blow up after growing several particles" do
  	# renderer.expect(:render, nil, [seed])
  	# 10.times { renderer.expect(:render, nil, [Particle]) }

    -> { 10.times { dla.grow } }.must_be_silent
    dla.size.must_equal 11
  end

end
