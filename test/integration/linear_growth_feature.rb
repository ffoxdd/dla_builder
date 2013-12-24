require_relative "../test_helper.rb"
require_relative '../../app/dla.rb'

describe "Linear DLA Growth" do

  let(:seed) { [Particle.new(0, 0, 2)] }
  let(:renderer) { MiniTest::Mock.new }
  let(:dla) { Dla.new(seeds: seed, radius: 2.0, overlap: 0.5) }

  it "does not blow up after growing several particles" do
  	renderer.expect(:render, nil, [seed])
  	10.times { renderer.expect(:render, nil, [Particle]) }

    -> { 10.times { dla.grow } }.must_be_silent
    dla.size.must_equal 11
  end

end
