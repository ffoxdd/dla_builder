require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }
  let(:grower_source) { MiniTest::Mock.new }

  let(:seed) { Object.new }
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
      let(:different_seed) { Object.new }
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
    let(:new_particle) { Object.new }

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

end
