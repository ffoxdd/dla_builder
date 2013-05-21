require 'benchmark'

class AlgorithmBenchmark

  def initialize(&algorithm)
    raise ArgumentError unless block_given?
    @algorithm = algorithm

    @ranges = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]
    @trial_count = 100
    @benchmark_trials = {}
  end

  def perform
    @ranges.each do |n|
      @benchmark_trials[n] ||= []

      until @benchmark_trials[n].size >= @trial_count do
        @benchmark_trials[n].push(benchmark(n))
        save
      end
    end
  end

  def save
    File.open(self.class.filename, 'w') do |file|
      YAML::dump(@benchmark_trials, file)
    end
  end

  def self.load
    @benchmark_trials = YAML::load_file(filename)
  end

  private

  attr_accessor :benchmark_trials

  def benchmark(n)
    Benchmark.benchmark { |b| b.report { @algorithm.call(n) } }.first
  end

  def self.filename
    File.join(File.dirname(__FILE__), "algorithm_benchmark-001.yml")
  end
  
end


require_relative '../sketchbook/lib/dla.rb'

algorithm_benchmark = AlgorithmBenchmark.new { |n| dla = Dla.new; n.times { dla.grow } }
algorithm_benchmark.perform

algorithm_benchmark.save
