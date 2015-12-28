require_relative "../../test_helper.rb"
require_relative "../../support/dcel_test_helper.rb"
require_relative "../../../app/dcel/face"
require_relative "../../../app/dcel/vertex"
require_relative "../../../app/point"

describe DCEL::Face do

  describe "#opposite_face" do
    # TODO
  end

  describe "#each_edge" do
    # TODO
  end

  describe "#each_vertex" do
    # TODO
  end

  describe "#eql?/#hash" do
    def test_face
      DCEL::Face.new(Object.new)
    end

    let(:face) { test_face }
    let(:different_face) { test_face }

    it "only represents equality for identical instances" do
      face.eql?(face).must_equal(true)
      face.eql?(different_face).must_equal(false)

      face.hash.wont_equal(different_face.hash)
    end
  end

end
