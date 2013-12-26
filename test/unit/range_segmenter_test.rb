require_relative "../test_helper.rb"
require_relative "../../lib/range_segmenter.rb"

describe RangeSegmenter do

  it "segments the range into n equal parts" do
    segments = RangeSegmenter.new(1...3, 4).segments
    segments.must_equal [1.0...1.5, 1.5...2.0, 2.0...2.5, 2.5...3.0]
  end

  it "maintains the open/closed property of the last segment" do
    segments = RangeSegmenter.new(1..4, 2).segments
    segments.last.exclude_end?.must_equal false
  end

end
