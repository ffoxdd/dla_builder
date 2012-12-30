require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }

  let(:seed) { Object.new }
  let(:seeds) { [seed] }
  before { renderer.expect(:render, true, [seed]) }

  let(:options) do
    { renderer: renderer,
      grower: grower,
      seeds: seed }
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
    let(:dla) { Dla.new(options) }

    before do
      grower.expect(:grow, new_particle, [seeds])
      renderer.expect(:render, true, [new_particle])
    end

    it "calls through to the grower" do
      dla.grow
      grower.verify
    end

    it "renders a new particle onto the aggregate" do
      dla.grow
      renderer.verify
    end

    it "increases the number of particles" do
      dla.grow
      dla.size.must_equal 2
    end
  end

end

