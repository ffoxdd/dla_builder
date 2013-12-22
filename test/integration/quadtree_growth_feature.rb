require_relative "../test_helper.rb"
require_relative '../../app/dla.rb'

describe "Quadtree DLA Growth" do

  let(:seed) { Particle.new(0, 0, 2) }
  let(:particles) { QuadtreeParticleCollection.new(2.0) }

  let(:dla) do
  	Dla.new :particles => particles, :seeds => seed, :radius => 2.0, :overlap => 0.5
  end

  it "does not blow up after growing several particles" do
    -> { 10.times { dla.grow } }.must_be_silent
    dla.size.must_equal 11
  end

end
