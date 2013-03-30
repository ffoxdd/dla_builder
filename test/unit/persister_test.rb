require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative "../../lib/persister.rb"

describe Persister do

  describe ".save" do
    after { File.delete("data/filename.yml") }

    let(:object) { Object.new }
    let(:saved_file) { File.open("data/filename.yml", "rb") { |f| f.read } }

    it "serializes to yaml and saves to the data directory" do
      Persister.save(object, "filename")
      saved_file.must_equal "--- !ruby/object {}\n"
    end
  end

end
