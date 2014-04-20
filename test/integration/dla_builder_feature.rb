require_relative "../test_helper.rb"
require_relative '../../app/dla_builder.rb'

describe "DLA Builder" do

  let(:builder) { DlaBuilder.new(limit: 10) }

  it "grows" do
    -> { builder.build }.must_be_silent
  end

end
