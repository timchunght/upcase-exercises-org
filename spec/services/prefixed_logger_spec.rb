require 'spec_helper'

describe PrefixedLogger do
  %w(debug info warn error fatal).each do |level|
    describe "##{level}" do
      it 'delegates to its logger with a prefix' do
        logger = double('logger')
        allow(logger).to receive(level.to_sym)
        prefixed = PrefixedLogger.new(logger, 'PREFIX: ')

        prefixed.send(level, 'message')

        expect(logger).to have_received(level.to_sym).with('PREFIX: message')
      end
    end
  end
end
