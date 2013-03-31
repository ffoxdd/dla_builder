require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative '../../sketchbook/lib/dla.rb'

describe "Simple DLA Growth" do

  let(:seed) { [Particle.new(0, 0, 2)] }
  let(:renderer) { MiniTest::Mock.new }
  let(:dla) { Dla.new(:seeds => seed, :radius => 2.0, :overlap => 0.5) }

  it "does not blow up after growing several particles" do
  	renderer.expect(:render, nil, [seed])
  	10.times { renderer.expect(:render, nil, [Particle]) }

    -> { 10.times { dla.grow } }.must_be_silent
  end

end
