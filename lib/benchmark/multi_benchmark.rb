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
    @benchmark_tests ||= tests.map do |n, trial_count|
      BenchmarkTest.new(n, trial_count, &test_block)
    end
  end

  class BenchmarkTest
    def initialize(n, trial_count, &test_block)
      @n = n
      @trial_count = trial_count
      @test_block = test_block
    end

    def result_hash
      {n: n, trials: trials, average_time: average_time}
    end

    private
    attr_reader :n, :trial_count, :test_block

    def trials
      @trials ||= trial_count.times.map { trial_real_time }
    end

    def trial_real_time
      Benchmark.measure { test_block.call(n) }.real
    end

    def average_time
      trials.inject(&:+) / trial_count
    end
  end

end
