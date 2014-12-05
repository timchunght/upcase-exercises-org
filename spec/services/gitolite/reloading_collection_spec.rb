require 'spec_helper'

describe Gitolite::ReloadingCollection do
  it 'is enumerable' do
    relation = double('relation')
    live_collection = Gitolite::ReloadingCollection.new(relation)

    expect(live_collection).to be_a(Enumerable)
  end

  describe '#each' do
    it 'reloads the relation before yielding' do
      reloaded = %w(one two three)
      relation = double('relation', reload: reloaded)
      live_collection = Gitolite::ReloadingCollection.new(relation)
      result = []

      live_collection.each do |item|
        result << item
      end

      expect(result).to eq(reloaded)
    end
  end

  shared_examples_for "relation delegation" do |method_name:|
    describe "##{method_name}" do
      it "delegates directly to the relation" do
        argument = double("argument")
        record = double("record")
        relation = double("relation")
        allow(relation).
          to receive(method_name).
          with(argument).
          and_return(record)
        reloading_collection = Gitolite::ReloadingCollection.new(relation)

        result = reloading_collection.__send__(method_name, argument)

        expect(result).to eq(record)
      end
    end
  end

  describe "#find" do
    it_behaves_like "relation delegation", method_name: :find
  end

  describe "#new" do
    it_behaves_like "relation delegation", method_name: :new
  end
end
