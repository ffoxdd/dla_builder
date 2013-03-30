require 'yaml'

class Persister

  DATA_DIRECTORY = "data"

  def self.save(object, filename)
    File.open(full_filename(filename), 'w') do |file|
      YAML.dump(object, file)
    end
  end

  private

  def self.full_filename(filename)
    File.join(DATA_DIRECTORY, "#{filename}.yml")
  end

end
