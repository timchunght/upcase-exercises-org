require 'spec_helper'

describe DelayedMailer do
  describe '#deliver' do
    it 'creates a background job for the mailer' do
      delay_chain = double('delay_chain')
      allow(delay_chain).to receive(:example)
      mailer = double('mailer')
      allow(mailer).to receive(:example)
      allow(mailer).to receive(:delay).and_return(delay_chain)
      delayed_mailer = DelayedMailer.new(mailer)

      delayed_mailer.example.deliver

      expect(delay_chain).to have_received(:example)
    end
  end
end
