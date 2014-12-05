require 'spec_helper'

describe FilteredMessage do
  describe '#deliver' do
    context 'when the recipient is filtered' do
      it "doesn't deliver the message" do
        message = deliver_message(
          filter: 'filtered@example.com',
          recipient: 'filtered@example.com',
        )

        expect(message).not_to be_delivered
      end
    end

    context "when the recipient isn't filtered" do
      it 'delivers the message' do
        message = deliver_message(
          filter: 'filtered@example.com',
          recipient: 'other@example.com',
        )

        expect(message).to be_delivered
      end
    end
  end

  def deliver_message(attributes)
    double('message').tap do |message|
      allow(message).to receive(:deliver)
      FilteredMessage.new(message, attributes).deliver
    end
  end

  def be_delivered
    have_received(:deliver)
  end
end
