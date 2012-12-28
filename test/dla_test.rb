require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require "#{File.dirname(__FILE__)}/../lib/dla.rb"

describe Dla do

  let(:renderer) { MiniTest::Mock.new }
  after { renderer.verify }

  describe "#initialize" do
    let(:seed) { MiniTest::Mock.new }

    it "renders the seeds" do
      renderer.expect(:render, true, [@seed])
      dla = Dla.new(renderer, @seed)
    end

    it "requires a seed to be passed in" do
      -> { Dla.new(renderer) }.must_raise ArgumentError
    end
  end

  describe "#grow" do
    it "renders a new particle onto the aggregate" do
    end
  end

end

