require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../app/persister.rb"

describe Persister do

  let(:object) { Object.new }

  describe ".save" do
    after { File.delete("data/name.yml") }
    let(:saved_file) { File.open("data/name.yml", "rb") { |f| f.read } }

    it "serializes to yaml and saves to the data directory" do
      Persister.save(object, "name")
      saved_file.must_equal "--- !ruby/object {}\n"
    end
  end

  describe ".read" do
    before { Persister.save(object, "name") }

    it "reads in a persisted file from the data directory" do
      saved_object = Persister.read("name")
      saved_object.to_yaml.must_equal "--- !ruby/object {}\n"
    end
  end

end
