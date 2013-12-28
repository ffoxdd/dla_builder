require_relative "../test_helper.rb"
require_relative "../../app/tree_property_calculator.rb"

describe TreePropertyCalculator do

  let(:root) { Particle.new }    
  let(:p1) { Particle.new }
  let(:p2) { Particle.new }
  let(:p3) { Particle.new }
  let(:particles) { [root, p1, p2, p3] }

  before do
    root.add_child(p1)
    root.add_child(p2)
    p2.add_child(p3)      
  end

  describe "average_depth" do
    it "returns the average depth of the tree" do
      tree_property_calculator = TreePropertyCalculator.new(particles)
      tree_property_calculator.average_depth.must_equal(3.0 / 4.0)
    end
  end

  describe "average_branching_factor" do
    it "returns the average branching factor of the tree" do
      tree_property_calculator = TreePropertyCalculator.new(particles)
      tree_property_calculator.average_branching_factor.must_equal(3.0 / 4.0)
    end
  end

  describe "max_depth" do
    it "returns the max depth" do
      tree_property_calculator = TreePropertyCalculator.new(particles)
      tree_property_calculator.max_depth.must_equal 2
    end
  end

  describe "max_branching_factor" do
    it "returns the max branching factor" do
      tree_property_calculator = TreePropertyCalculator.new(particles)
      tree_property_calculator.max_branching_factor.must_equal 2
    end
  end

end
