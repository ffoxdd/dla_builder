require "benchmark"
require "yaml"

class MultiBenchmark

  def initialize(tests, &test_block)
    @tests = tests # [[n, trials], ...]
    @test_block = test_block
  end

  def print
    puts result_hashes.to_yaml
  end

  def result_hashes
    benchmark_tests.map(&:result_hash)
  end

  private
  attr_reader :tests, :test_block

  def benchmark_tests
    @benchmark_tests ||= tests.map do |n, trials|
      BenchmarkTest.new(n, trials, &test_block)
    end
  end

  class BenchmarkTest
    def initialize(n, trials, &test_block)
      @n = n
      @trials = trials
      @test_block = test_block
    end

    def result_hash
      {n: n, trials: trials, average_time: average_time}
    end

    private
    attr_reader :n, :trials, :test_block

    def result
      @result ||= Benchmark.measure do
        trials.times.map { test_block.call(n) }
      end
    end

    def average_time
      result.real / trials
    end
  end

end
