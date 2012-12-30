require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require "#{File.dirname(__FILE__)}/../lib/dla.rb"

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
  end

end

