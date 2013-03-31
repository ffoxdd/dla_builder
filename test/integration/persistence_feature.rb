require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative '../../sketchbook/lib/dla.rb'

describe "DLA Persistence" do

	let(:dla) { Dla.new }

	before do
		10.times { dla.grow }
		dla.size.must_equal 11
	end

	after { File.delete("data/persistence_feature_dla.yml") }

	it "saves and reads a DLA from disk" do
		dla.save("persistence_feature_dla")
		read_dla = Persister.read("persistence_feature_dla")
		
		read_dla.size.must_equal dla.size
	end

end
