require 'spec_helper'

describe DecoratingRelation do
  DecoratingRelation::ITEM_METHODS.each do |method_name|
    describe "##{method_name}" do
      context 'with a matching record' do
        it 'returns the decorated clone' do
          arguments = %w(one two)
          record = double('record')
          decorated_record = double('decorated_record')
          relation = double('relation')
          allow(relation).
            to receive(method_name).
            with(*arguments).
            and_return(record)
          decorator = double('decorator')
          allow(decorator).
            to receive(:new).
            with(record: record).
            and_return(decorated_record)
          decorating_relation =
            DecoratingRelation.new(relation, :record, decorator)

          result = decorating_relation.send(method_name, *arguments)

          expect(result).to eq(decorated_record)
        end
      end

      context 'with no matching records' do
        it 'returns nil' do
          relation = double('relation', method_name => nil)
          decorating_relation =
            DecoratingRelation.new(relation, :record, double('decorator'))

          result = decorating_relation.send(method_name, 'arguments')

          expect(result).to be_nil
        end
      end
    end
  end

  describe '#each' do
    it 'decorates each yielded instance' do
      records = [double(name: "one"), double(name: "two")]
      decorator = Struct.new(:decorator) do
        def initialize(hash)
          @name = hash.fetch(:record).name
        end

        def to_s
          @name
        end
      end
      result = []
      decorating_relation =
        DecoratingRelation.new(records, :record, decorator)

      decorating_relation.each { |yielded| result << yielded }

      expect(result.map(&:to_s)).to eq(%w(one two))
    end
  end

  it "is enumerable" do
    records = []
    decorator = double()
    decorating_relation = DecoratingRelation.new(records, :record, decorator)

    expect(decorating_relation).to be_a(Enumerable)
  end
end
