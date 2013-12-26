require_relative "../test_helper.rb"
require_relative "../../app/persister.rb"

describe Persister do

  let(:object) { Object.new }
  let(:persister) { Persister.new(object, "name") }

  after { File.delete("data/name.yml") }

  describe "#save" do
    let(:saved_file) { File.open("data/name.yml", "rb") { |f| f.read } }

    it "serializes to yaml and saves to the data directory" do
      persister.save
      saved_file.must_equal "--- !ruby/object {}\n"
    end
  end

  describe ".read" do
    before { persister.save }

    it "reads in a persisted file from the data directory" do
      saved_object = Persister.read("name")
      saved_object.to_yaml.must_equal "--- !ruby/object {}\n"
    end
  end

end
