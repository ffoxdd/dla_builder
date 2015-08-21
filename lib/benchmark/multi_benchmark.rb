require "benchmark"
require "yaml"

class MultiBenchmark

  def initialize(tests, &test_block)
    @tests = tests # an array of test parameter hashes
    @test_block = test_block
  end

  def print
    puts to_h.to_yaml
  end

  def to_h
    benchmark_tests.map(&:to_h)
  end

  private
  attr_reader :tests, :test_block

  def benchmark_tests
    @benchmark_tests ||= tests.map do |test_parameters|
      BenchmarkTest.new(test_parameters, &test_block)
    end
  end

  class BenchmarkTest
    def initialize(test_parameters = {}, &test_block)
      @test_parameters = test_parameters
      @trial_count = test_parameters.delete(:trial_count) || 1
      @test_block = test_block
    end

    def to_h
      test_parameters.merge(trials: trials, average_time: average_time)
    end

    private
    attr_reader :test_parameters, :trial_count, :test_block

    def trials
      @trials ||= trial_count.times.map { trial_time }
    end

    def trial_time
      Benchmark.measure { test_block.call(test_parameters) }.real
    end

    def average_time
      trials.inject(&:+) / trial_count
    end
  end

end
