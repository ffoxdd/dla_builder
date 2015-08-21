require_relative "multi_benchmark"
require_relative "../../app/dla"
require "yaml"

class DlaBenchmark

  def to_h
    {context_hash => results_hash}
  end

  private

  def multi_benchmark
    @multi_benchmark ||= MultiBenchmark.new(tests) do |test_parameters|
      grow_dla(test_parameters[:particle_count])
    end
  end

  def grow_dla(particle_count)
    Dla.new.tap { |dla| particle_count.times { dla.grow }}
  end

  def tests
    [
      {particle_count: 8, trial_count: 8},
      {particle_count: 32, trial_count: 8},
      {particle_count: 128, trial_count: 8},
      {particle_count: 1024, trial_count: 8},
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
