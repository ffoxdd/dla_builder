require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }
  let(:grower_source) { MiniTest::Mock.new }

  let(:seed) { mock_particle }
  let(:seeds) { [seed] }
  before { renderer.expect(:render, true, [seed]) }

  let(:options) do
    { 
      :renderer => renderer, 
      :grower_source => grower_source, 
      :seeds => seed, 
      :radius => 2.0,
      :overlap => 0.5
    } 
  end
  
  describe "#initialize" do
    it "renders the seeds" do
      dla = Dla.new(:renderer => renderer, :seeds => seed)
      renderer.verify
    end

    describe "multiple seeds" do
      let(:different_seed) { mock_particle }
      let(:options) { {:renderer => renderer, :seeds => [seed, different_seed]} }

      it "allows multiple seeds to be passed in" do
        renderer.expect(:render, true, [different_seed])
        -> { Dla.new(options) }.must_be_silent
        renderer.verify
      end
    end
  end

  describe "#size" do
    it "returns the number of seeds when no new particles have been added" do
      dla = Dla.new(:seeds => seed)
      dla.size.must_equal 1
    end
  end

  describe "#grow" do
    let(:new_particle) { mock_particle }

    let(:options) do
      {
        :renderer => renderer,
        :grower_source => grower_source,
        :seeds => seed,
        :radius => 2.0,
        :overlap => 0.5
      }
    end

    it "calls through to the grower and renders a new particle onto the aggregate" do
      grower_source.expect(:new, grower, [seeds, {:radius => 2.0, :overlap => 0.5}])
      grower.expect(:grow, new_particle)
      renderer.expect(:render, true, [new_particle])

      dla = Dla.new(options)
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
    it "returns true when within the given bounds" do
      seeds = [mock_particle(1, 1)]
      dla = Dla.new(:seeds => seeds)

      dla.within_bounds?(-2..2, -2..2).must_equal true
    end

    it "returns false when outside the given x range" do
      seeds = [mock_particle(1, 1), mock_particle(2.5, 1)]
      dla = Dla.new(:seeds => seeds)

      dla.within_bounds?(-2..2, -2..2).must_equal false
    end

    it "returns false when outside the given y range" do
      seeds = [mock_particle(1, 1), mock_particle(1, 2.5)]
      dla = Dla.new(:seeds => seeds)

      dla.within_bounds?(-2..2, -2..2).must_equal false
    end
  end

  private

  def mock_particle(x_extent = 1, y_extent = 1)
    OpenStruct.new(
      :extent => Math.hypot(x_extent, y_extent),
      :x_extent => x_extent,
      :y_extent => y_extent
    )
  end

end
