require_relative "multi_benchmark"
require_relative "../app/dla"
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
    @multi_benchmark ||= MultiBenchmark.new(tests) do |n|
      Dla.new.tap { |dla| n.times { dla.grow }}
    end
  end

  def tests
    # [[8, 8], [32, 4], [128, 2], [1024, 1]]
    [[8, 8], [32, 4]]
  end

  def sha
    `git rev-parse HEAD`.strip
  end

  def ruby_version
    "#{RUBY_ENGINE} #{RUBY_VERSION}"
  end

  def computer_name
    `hostname -s`.strip
  end

  def context_hash
    {computer_name: computer_name, ruby_version: ruby_version, sha: sha}
  end

  def results_hash
    {results: multi_benchmark.result_hashes}
  end

end
