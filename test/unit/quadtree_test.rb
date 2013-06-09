require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require 'set'

require_relative "../../sketchbook/lib/quadtree.rb"

describe Quadtree do

  describe "#initialize" do
    it "doesn't blow up" do
      -> { Quadtree.new(0...1, 0...1) }.must_be_silent
    end
    
    it "starts off with zero particles" do
      quadtree = Quadtree.new(0...1, 0...1)
      quadtree.size.must_equal 0      
    end

    it "start off with zero depth" do
      quadtree = Quadtree.new(0...1, 0...1)
      quadtree.depth.must_equal 0
    end
  end

  describe "#<<" do
    let(:quadtree) { Quadtree.new(0...1, 0...1, :max_depth => 3) }

    it "adds a particle" do
      quadtree << mock_particle(0.5, 0.5)
      quadtree.size.must_equal 1
    end

    it "doesn't add a particle if it is outside the tree's bounds" do
      quadtree << mock_particle(2, 2)
      quadtree.size.must_equal 0
    end

    it "subdivides to the maximum depth upon adding the first particle" do
      quadtree << mock_particle(0.5, 0.5)
      quadtree.depth.must_equal 3
    end
  end

  describe "#covers?" do
    let(:quadtree) { Quadtree.new(0...1, 0...1) }

    it "returns true if the quadtree covers the particle" do
      quadtree.covers?(mock_particle(0, 0)).must_equal true
      quadtree.covers?(mock_particle(0.5, 0.5)).must_equal true
      quadtree.covers?(mock_particle(0.999, 0.999)).must_equal true

      quadtree.covers?(mock_particle(1, 0)).must_equal false
      quadtree.covers?(mock_particle(0, 1)).must_equal false
      quadtree.covers?(mock_particle(0.5, 2)).must_equal false
      quadtree.covers?(mock_particle(2, 0.5)).must_equal false
      quadtree.covers?(mock_particle(10, 10)).must_equal false
    end
  end

  describe "#within" do
    describe "finding particles" do
      let(:quadtree) { Quadtree.new(0...10, 0...10) }

      let(:inside_particles) do
        [mock_particle(2, 2), mock_particle(3, 3), mock_particle(2.5, 2.5)]
      end

      let(:outside_particles) do
        [mock_particle(1, 1), mock_particle(2, 3.1), mock_particle(3, 0.5)]
      end

      before do
        inside_particles.each { |particle| quadtree << particle }
        outside_particles.each { |particle| quadtree << particle }
      end

      it "returns all particles within the given bounds" do
        Set.new(quadtree.within(2..3, 2..3)).must_equal Set.new(inside_particles)
      end
    end

    describe "optimized search" do
      let(:q0_particle) { MiniTest::Mock.new }
      let(:q3_particle) { MiniTest::Mock.new }

      describe "for a tree of depth 0" do
        let(:quadtree) { Quadtree.new(0...10, 0...10, :max_depth => 0) }

        before do
          q0_particle.expect(:x, 1)
          q0_particle.expect(:y, 1)

          q3_particle.expect(:x, 9)
          q3_particle.expect(:y, 9)

          quadtree << q0_particle
          quadtree << q3_particle
        end

        it "searches all particles" do
          q0_particle.expect(:x, 1)
          q0_particle.expect(:y, 1)

          q3_particle.expect(:x, 9)
          q3_particle.expect(:y, 9)

          quadtree.within(0..2, 0..2).must_equal [q0_particle]
          q0_particle.verify
          q3_particle.verify
        end
      end

      describe "for a tree of depth greater than 0" do
        let(:quadtree) { Quadtree.new(0...10, 0...10, :max_depth => 1) }

        before do
          3.times do
            q0_particle.expect(:x, 1)
            q0_particle.expect(:y, 1)

            q3_particle.expect(:x, 9)
            q3_particle.expect(:y, 9)
          end

          quadtree << q0_particle
          quadtree << q3_particle
        end

        it "doesn't search all particles" do
          q0_particle.expect(:x, 1)
          q0_particle.expect(:y, 1)

          quadtree.within(0..2, 0..2).must_equal [q0_particle]
          q0_particle.verify
          q3_particle.verify
        end
      end
    end
  end

  private

  require 'ostruct'

  def mock_particle(x = 1, y = 1)
    OpenStruct.new(:x => x, :y => y)
  end

end
