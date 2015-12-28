require_relative "../../../test_helper.rb"
require_relative "../../../../lib/enumerators/enumerator_helpers"

describe "EnumeratorHelpers" do

  describe "#enumerator_select" do
    let(:enumerator) { [1,2,3,4].each }

    it "yields values that pass the given condition" do
      filtered_enumerator = EnumeratorHelpers.enumerator_select(enumerator, &:even?)

      filtered_enumerator.next.must_equal(2)
      filtered_enumerator.next.must_equal(4)
    end
  end

  describe "#enumerator_reject" do
    let(:enumerator) { [1,2,3,4].each }

    it "yields values that pass the given condition" do
      filtered_enumerator = EnumeratorHelpers.enumerator_reject(enumerator, &:even?)

      filtered_enumerator.next.must_equal(1)
      filtered_enumerator.next.must_equal(3)
    end
  end

end
