require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require "#{File.dirname(__FILE__)}/../lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:grower) { MiniTest::Mock.new }

  let(:seed) { MiniTest::Mock.new }
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
  end

  describe "#grow" do
    let(:new_particle) { MiniTest::Mock.new }
    let(:dla) { Dla.new(options) }

    before do
      grower.expect(:grow, new_particle, [seed])
      renderer.expect(:render, true, [new_particle])
      seed.expect(:==, true, [Object])
    end

    it "calls through to the grower" do
      dla.grow
      grower.verify
    end

    # it "renders a new particle onto the aggregate" do
      # dla.grow
      # renderer.verify
    # end
  end

end

