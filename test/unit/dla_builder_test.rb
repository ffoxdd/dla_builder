require 'ostruct'
require_relative "../test_helper.rb"
require_relative "../../app/dla_builder.rb"

describe DlaBuilder do

  describe "#initialize" do
    let(:mock_dla) { Object.new }

    let :dla_new_stub do
      lambda do |options|
        options[:particle_radius].must_equal 1.5
        options[:overlap].must_equal 0.5
        options[:seeds].must_equal [seed]

        mock_dla
      end
    end

    let(:seed) { Object.new }

    it "passes options along to the DLA" do
      Dla.stub(:new, dla_new_stub) do
        DlaBuilder.new(particle_radius: 1.5, overlap: 0.5, seeds: [seed])
      end
    end
  end

  describe "#grow" do
    describe "with the limit option" do
      let :dla do
        OpenStruct.new(size: 1).tap do |o|
          def o.grow; self.size += 1; end
        end
      end

      let(:builder) { DlaBuilder.new(limit: 3) }

      it "grows the specified number of particles" do
        Dla.stub(:new, dla) { builder.grow }
        dla.size.must_equal 3
      end
    end
  end

end
