require 'yaml'

class Persister

  DATA_DIRECTORY = File.join(File.dirname(__FILE__), "..", "data")

  def self.save(object, name)
    File.open(filename(name), 'w') do |file|
      YAML::dump(object, file)
    end
  end

  def self.read(name)
    YAML::load_file(filename(name))
  end

  private

  def self.filename(name)
    File.join(DATA_DIRECTORY, "#{name}.yml")
  end

end
