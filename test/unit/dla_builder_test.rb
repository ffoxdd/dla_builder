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

  describe "#build" do
    describe "with the limit option" do
      let :mock_dla do
        OpenStruct.new(size: 1).tap do |o|
          def o.grow; self.size += 1; end
        end
      end

      let(:builder) { DlaBuilder.new(limit: 3) }

      it "grows the specified number of particles" do
        Dla.stub(:new, mock_dla) do
          dla = builder.build
          dla.size.must_equal 3
        end
      end
    end

    describe "with the within option" do
      let :mock_dla do
        OpenStruct.new(size: 1).tap do |o|
          def o.grow; self.size += 1; end
          def o.within?(bb); size < 4; end
        end
      end

      let(:builder) { DlaBuilder.new(within: [0..1, 0..1]) }

      it "grows until the dla is not within the bounding box" do
        Dla.stub(:new, mock_dla) do
          dla = builder.build
          dla.size.must_equal 4
        end
      end
    end
  end

end
