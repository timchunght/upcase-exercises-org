require "spec_helper"

describe MemoizedEnumerable do
  it "is Enumerable" do
    expect(MemoizedEnumerable.new([])).to be_a(Enumerable)
  end

  describe "#each" do
    context "for the first run" do
      it "delegates to its source" do
        source = double("source", to_a: [1, 2, 3])
        memoized_enumerable = MemoizedEnumerable.new(source)
        result = []

        memoized_enumerable.each { |yielded| result << yielded }

        expect(result).to eq([1, 2, 3])
      end
    end

    context "for each subsequent run" do
      it "uses the memoized result" do
        source = double("source", to_a: [1, 2, 3])
        memoized_enumerable = MemoizedEnumerable.new(source)
        memoized_enumerable.each { |_| }
        result = []

        memoized_enumerable.each { |yielded| result << yielded }

        expect(result).to eq([1, 2, 3])
        expect(source).to have_received(:to_a).once
      end
    end
  end
end
