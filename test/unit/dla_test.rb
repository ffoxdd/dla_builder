require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/dla.rb"
require_relative "../../sketchbook/lib/linear_particle_collection.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }
  let(:grower_source) { MiniTest::Mock.new }

  let(:seed) { test_particle }
  let(:seeds) { [seed] }
  let(:particles) { LinearParticleCollection.new }

  let(:options) do
    { 
      :renderer => renderer, 
      :grower_source => grower_source, 
      :seeds => seeds,
      :particles => particles,

      :radius => 2.0,
      :overlap => 0.5,

      :auto_render => false
    } 
  end
  
  describe "#initialize" do
    it "succeeds when collaborators are passed in" do
      ->{ Dla.new(options) }.must_be_silent
    end

    it "succeeds without default collaborators" do
      ->{ Dla.new(:auto_render => false) }.must_be_silent
    end

    it "renders the seeds when :auto_render is set to true" do
      seeds.each { |seed| renderer.expect(:render, nil, [seed]) }
      Dla.new(:seeds => seeds, :renderer => renderer, :auto_render => true)
      renderer.verify
    end
  end

  describe "#size" do
    it "returns the number of seeds when no new particles have been added" do
      dla = Dla.new(:seeds => seeds)
      dla.size.must_equal 1
    end
  end

  describe "#grow" do
    let(:new_particle) { test_particle }
    let(:dla) { Dla.new(options) }

    it "calls through to the grower and renders a new particle onto the aggregate" do
      grower_source.expect(:new, grower, [particles, 2.0, 0.5, 0.5])
      grower.expect(:grow, new_particle)
      renderer.expect(:render, true, [new_particle])

      dla.grow

      grower.verify
      renderer.verify

      dla.size.must_equal 2
    end
  end

  describe "#save" do
    let(:persister) { MiniTest::Mock.new }
    let(:dla) { Dla.new(:persister => persister) }

    it "persists by calling through to the persister" do
      persister.expect(:save, nil, [dla, "filename"])
      dla.save("filename")
      persister.verify
    end
  end

  describe "#within_bounds?" do
    let(:seeds) { [test_particle(1, 0, 1), test_particle(0, 1, 1)] }
    let(:dla) { Dla.new(:seeds => seeds) }

    it "returns true when within the given bounds" do
      dla.within_bounds?(-2..2, -2..2).must_equal true
    end

    it "returns false when outside the given x range" do
      dla.within_bounds?(-1..1, -2..2).must_equal false
    end

    it "returns false when outside the given y range" do
      dla.within_bounds?(-2..2, -1..1).must_equal false
    end
  end

  describe "#render" do
    let(:dla) { Dla.new(:seeds => seeds, :renderer => renderer, :auto_render => false) }

    it "renders all the particles" do
      seeds.each { |seed| renderer.expect(:render, nil, [seed]) }
      dla.render
      renderer.verify
    end
  end

  describe "#renderer=" do
    let(:renderer) { MiniTest::Mock.new }
    let(:dla) { Dla.new(:seeds => seeds, :auto_render => false) }

    it "uses the assigned renderer" do
      renderer.expect(:render, nil, [seed])

      dla.renderer = renderer
      dla.render

      renderer.verify
    end
  end

  private

  def test_particle(x = 0, y = 0, r = 0.5)
    Particle.new(x, y, 0.5)
  end

end
