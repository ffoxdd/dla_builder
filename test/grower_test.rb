require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../lib/grower.rb"

# TODO: remove the dependency on particle.rb
#   Interface:
#     Particle#magnitude
#     Particle#distance
#     Particle#step
#     ParticleSource.new(x, y, radius)

require_relative "../lib/particle.rb"

describe Grower do

  let(:particle_source) { Particle }
  let(:options) { {particle_source: particle_source} }

  describe "#initialize" do
    it "does not blow up" do
      -> { Grower.new([], options) }.must_be_silent
    end
  end

  describe "#grow" do
    let(:existing_particles) do
      [ Particle.new(0, 0, 1),
        Particle.new(2, 0, 1),
        Particle.new(-2, 0, 1),
        Particle.new(0, 2, 1),
        Particle.new(0, -2, 1) ]
    end

    let(:grower) do
      Grower.new existing_particles, options.merge(overlap: 0.1)
    end

    it "returns a new particle attached to the aggregate" do
      new_particle = grower.grow
      magnitude = new_particle.magnitude

      new_particle.wont_be_nil
      magnitude.must_be :>=, 0.9
      magnitude.must_be :<=, 4.0
    end
  end

end

