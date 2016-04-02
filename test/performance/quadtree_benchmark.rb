require_relative '../../app/particle_collection'
require_relative '../../app/particle'
require_relative '../../app/vector2d'
require 'benchmark'

class QaudtreeBenchmark
  def self.run
    new.run
  end

  def run
    Benchmark.bm(7) do |x|
      bench_range.each do |n|
        x.report("#{n}:") { test_particle_collection(n).closest_particle(test_particle) }
      end
    end
  end

  private

  def test_particle
    Particle.new(center: Vector2D[0, 0])
  end

  def test_particle_collection(n)
    ParticleCollection.new(1).tap do |collection|
      n.times { collection << Particle.new(center: Vector2D.random(1000)) }
    end
  end

  def bench_range
    @bench_range ||= [1, 10, 100, 1000]
  end
end

QaudtreeBenchmark.run
