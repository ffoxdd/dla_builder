require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }
  let(:grower_source) { MiniTest::Mock.new }

  let(:seed) { Object.new }
  let(:seeds) { [seed] }
  before { renderer.expect(:render, true, [seed]) }

  let(:options) do
    { renderer: renderer, grower_source: grower_source, seeds: seed } 
  end
  
  describe "#initialize" do
    it "renders the seeds" do
      dla = Dla.new(options)
      renderer.verify
    end

    let(:different_seed) { Object.new }

    it "allows multiple seeds to be passed in" do
      options[:seeds] = [seed, different_seed]
      renderer.expect(:render, true, [different_seed])
      -> { Dla.new(options) }.must_be_silent
    end
  end

  describe "#size" do
    it "returns the number of seeds when no new particles have been added" do
      dla = Dla.new(options)
      dla.size.must_equal 1
    end
  end

  describe "#grow" do
    let(:new_particle) { Object.new }

    it "calls through to the grower and renders a new particle onto the aggregate" do
      grower_source.expect(:new, grower, [seeds])
      grower.expect(:grow, new_particle)
      renderer.expect(:render, true, [new_particle])

      dla = Dla.new(options)
      dla.grow

      grower.verify
      renderer.verify

      dla.size.must_equal 2
    end

    describe "grower options" do
      it "passes options through to the grower" do
        grower_source.expect(:new, grower, [seeds])
        grower.expect(:grow, new_particle)
        renderer.expect(:render, true, [new_particle])

        dla = Dla.new(options.merge(overlap: 0.5))
        dla.grow

        grower.verify
      end
    end
  end

end

