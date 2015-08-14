require_relative "multi_benchmark"
require_relative "../app/dla"
require "forwardable"
require "yaml"

class DlaBenchmark

  extend Forwardable
  def_delegators :multi_benchmark, :print

  def result_hash
    {
      sha: sha,
      ruby_version: ruby_version,
      results: multi_benchmark.result_hashes
    }
  end

  private

  def multi_benchmark
    @multi_benchmark ||= MultiBenchmark.new(tests) do |n|
      Dla.new.tap { |dla| n.times { dla.grow }}
    end
  end

  def tests
    [[8, 8], [32, 4], [128, 2], [1024, 1]]
  end

  def sha
    system "git rev-parse HEAD"
  end

  def ruby_version
    "#{RUBY_ENGINE} #{RUBY_VERSION}"
  end

end

puts DlaBenchmark.new.result_hash.to_yaml
