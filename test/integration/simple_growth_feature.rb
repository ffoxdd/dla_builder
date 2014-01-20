require_relative "../test_helper.rb"
require_relative '../../app/dla.rb'

describe "Simple DLA Growth" do

  let(:seed) { [Particle.new(radius: 1)] }
  let(:dla) { Dla.new(radius: 1, seeds: seed) }

  it "grows particles onto an aggregate" do
    -> { 10.times { dla.grow } }.must_be_silent
    dla.size.must_equal 11
    dla.within?(BoundingBox.new(-3..3, -3..3)).must_equal false
  end

end
