require 'yaml'

class Persister

  def initialize(object, name)
    @object = object
    @name = name
  end

  def save
    File.open(Persister.filename(name), 'w') do |file|
      YAML::dump(object, file)
    end
  end

  def self.read(name)
    YAML::load_file(filename(name))
  end

  private

    attr_reader :object, :name

    DATA_DIRECTORY = File.join(File.dirname(__FILE__), "..", "data")

    def self.filename(name)
      File.join(DATA_DIRECTORY, "#{name}.yml")
    end

end
