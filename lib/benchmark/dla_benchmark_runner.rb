require_relative "dla_benchmark"
require "yaml"

class DlaBenchmarkRunner
  def self.run
    new.run
  end

  def run
    save(benchmarks_data.merge(current_benchmark))
  end

  private

  BENCHMARKS_FILE_PATH = "./data/benchmarks.yml"

  def current_benchmark
    @current_benchmark ||= DlaBenchmark.new.to_h
  end

  def benchmarks_data
    return {} unless File.exists?(BENCHMARKS_FILE_PATH)
    @benchmarks_data ||= YAML.load_file(BENCHMARKS_FILE_PATH)
  end

  def save(data)
    File.open(BENCHMARKS_FILE_PATH, 'w') { |f| f << YAML.dump(data) }
  end
end
