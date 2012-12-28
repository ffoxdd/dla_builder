require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require "#{File.dirname(__FILE__)}/../lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  let(:particle_source) { MiniTest::Mock.new }

  describe "#initialize" do
    let(:seed) { MiniTest::Mock.new }

    it "renders the seeds" do
      renderer.expect(:render, true, [seed])
      dla = Dla.new(renderer, particle_source, seed)

      renderer.verify
    end

    it "requires a seed to be passed in" do
      -> { Dla.new(renderer, particle_source) }.must_raise ArgumentError
    end
  end

  describe "#grow" do
    let(:seed) { MiniTest::Mock.new }
    before { renderer.expect(:render, true, [seed]) }

    let(:new_particle) { MiniTest::Mock.new }
    after { particle_source.verify }

    let(:dla) { Dla.new(renderer, particle_source, seed) }

    it "renders a new particle onto the aggregate" do
      particle_source.expect(:new, new_particle)
      dla.grow

      particle_source.verify
    end
  end

end

