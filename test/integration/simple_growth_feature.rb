require_relative "../test_helper.rb"
require_relative '../../app/dla.rb'

describe "Linear DLA Growth" do
  let(:seed) { [Particle.new(0, 0, 2)] }
  let(:dla) { Dla.new }

  it "does not blow up after growing several particles" do
    -> { 10.times { dla.grow } }.must_be_silent
    dla.size.must_equal 11
  end

end
