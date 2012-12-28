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

    # TODO: test input assertions
    # it "requires a seed to be passed in" do
      # -> { dla = Dla.new(renderer) }.must_raise_error
    # end
  end

  describe "#grow" do
    it "renders a new particle onto the aggregate" do
    end
  end

end

