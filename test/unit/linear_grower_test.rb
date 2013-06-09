require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../sketchbook/lib/linear_grower.rb"
require_relative "../../sketchbook/lib/particle.rb" # TODO: remove the dependency on particle.rb

describe LinearGrower do

  let(:default_options) { {particle_source: Particle} }

  describe "#initialize" do
    it "does not blow up" do
      -> { LinearGrower.new([], default_options) }.must_be_silent
    end
  end

  describe "#grow" do
    let(:seed_particle) { Particle.new(0, 0, 10.0) }

    it "returns a new particle attached to the aggregate" do
      radius = 10
      overlap = 1

      existing_particle = Particle.new(0, 0, radius)
      options = default_options.merge(:radius => radius, :overlap => overlap)
      grower = LinearGrower.new([existing_particle], options)   

      new_particle = grower.grow
      magnitude = new_particle.magnitude

      new_particle.wont_be_nil
      magnitude.must_be :>=, radius * 2 - overlap
      magnitude.must_be :<=, radius * 2
    end

    it "doesn't grow the same way each time" do
      grower = LinearGrower.new([seed_particle], default_options)

      particle = grower.grow
      other_particle = grower.grow

      particle.x.wont_equal other_particle.x
      particle.y.wont_equal other_particle.y
    end

    it "makes more compact aggregates when overlap is large" do
      existing_particles = [
        Particle.new(0, 0, 10),
        Particle.new(20, 0, 10),
        Particle.new(-20, 0, 10),
        Particle.new(0, 20, 10),
        Particle.new(0, -20, 10)
      ]

      normal_options = default_options.merge(:radius => 10.0, :overlap => 0.1)
      compact_options = default_options.merge(:radius => 10.0, :overlap => 6.0)

      normal_grower = LinearGrower.new(existing_particles, normal_options)
      compact_grower = LinearGrower.new(existing_particles, compact_options)

      trials = 5

      normal_particles = trials.times.map { normal_grower.grow }
      compact_particles = trials.times.map { compact_grower.grow }

      normal_magnitude = average_by(normal_particles, &:magnitude)
      compact_magnitude = average_by(compact_particles, &:magnitude)

      compact_magnitude.must_be :<, normal_magnitude
    end
  end

  private

    def average_by(samples, &block)
      samples.map(&block).inject(&:+) / samples.size
    end

end

