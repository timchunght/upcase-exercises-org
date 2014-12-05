require "spec_helper"

describe ObservableRecord do
  it "delegates missing methods to its record" do
    expected = double("record.example")
    record = double("record", example: expected)
    observer = double("observer")
    observable_record = ObservableRecord.new(record, observer)

    result = observable_record.example

    expect(result).to eq(expected)
    expect(observable_record).to be_a(SimpleDelegator)
  end

  shared_examples_for "tracks save" do
    context "for a new, valid record" do
      it "notifies the observer of create and save" do
        record = FakeRecord.new(persisted: false, valid: true)
        observer = stub_observer
        observable_record = ObservableRecord.new(record, observer)

        result = save(observable_record)

        expect(result).to eq(true)
        expect(observer).to have_received(:saved).with(record)
        expect(observer).to have_received(:created).with(record)
        expect(observer).not_to have_received(:updated)
      end
    end

    context "for a new, invalid record" do
      it "doesn't notify the observer" do
        record = FakeRecord.new(persisted: false, valid: false)
        observer = stub_observer
        observable_record = ObservableRecord.new(record, observer)

        result = save(observable_record)

        expect(result).to eq(false)
        expect(observer).not_to have_received(:saved)
        expect(observer).not_to have_received(:created)
        expect(observer).not_to have_received(:updated)
      end
    end

    context "for an existing, valid record" do
      it "notifies the observer of update and save" do
        record = FakeRecord.new(persisted: true, valid: true)
        observer = stub_observer
        observable_record = ObservableRecord.new(record, observer)

        result = save(observable_record)

        expect(result).to eq(true)
        expect(observer).to have_received(:saved)
        expect(observer).to have_received(:updated)
        expect(observer).not_to have_received(:created)
      end
    end

    context "for an existing, invalid record" do
      it "doesn't notify the observer" do
        record = FakeRecord.new(persisted: true, valid: false)
        observer = stub_observer
        observable_record = ObservableRecord.new(record, observer)

        result = save(observable_record)

        expect(result).to eq(false)
        expect(observer).not_to have_received(:saved)
        expect(observer).not_to have_received(:created)
        expect(observer).not_to have_received(:updated)
      end
    end
  end

  describe "#save" do
    it_behaves_like "tracks save" do
      def save(record)
        record.save
      end
    end
  end

  describe "#update_attributes" do
    it_behaves_like "tracks save" do
      def save(record)
        record.update_attributes({})
      end
    end
  end

  def stub_observer
    double("observer").tap do |observer|
      allow(observer).to receive(:saved)
      allow(observer).to receive(:created)
      allow(observer).to receive(:updated)
    end
  end
end
