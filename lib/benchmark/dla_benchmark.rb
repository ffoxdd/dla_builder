require_relative "multi_benchmark"
require_relative "../../app/dla"
require "forwardable"
require "yaml"

class DlaBenchmark

  extend Forwardable
  def_delegators :multi_benchmark, :print

  def to_h
    {context_hash => results_hash}
  end

  private

  def multi_benchmark
    @multi_benchmark ||= MultiBenchmark.new(tests) do |test_parameters|
      Dla.new.tap { |dla| test_parameters[:n].times { dla.grow }}
    end
  end

  def tests
    [
      {n: 8, trial_count: 8},
      {n: 32, trial_count: 4},
      # {n: 128, trial_count: 2},
      # {n: 1024, trial_count: 1},
    ]
  end

  def context_hash
    Context.new.to_h
  end

  def results_hash
    {results: multi_benchmark.to_h}
  end

  class Context
    def to_h
      {computer_name: computer_name, ruby_version: ruby_version, sha: sha}
    end

    private

    def ruby_version
      "#{RUBY_ENGINE} #{RUBY_VERSION}"
    end

    def computer_name
      `hostname -s`.strip
    end

    def sha
      `git rev-parse HEAD`.strip
    end
  end

end
