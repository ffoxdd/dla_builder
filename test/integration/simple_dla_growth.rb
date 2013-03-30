require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative '../../lib/dla.rb'
require_relative '../../lib/grower.rb'
require_relative '../../lib/particle.rb'

describe "Simple DLA Growth" do

  # TODO: make assertions on the renderer calls

  let(:seeds) { [Particle.new(0, 0, 2)] }

  let(:options) do
    { 
      # :renderer => renderer
      :grower_source => Grower, 
      :seeds => seeds, 
      :radius => 2.0,
      :overlap => 0.5
    } 
  end

  let(:dla) { Dla.new(options) }

  it "does not blow up after growing several particles" do
    -> { 20.times { dla.grow } }.must_be_silent    
  end

end
