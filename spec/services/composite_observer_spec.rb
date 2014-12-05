require 'spec_helper'

describe CompositeObserver do
  describe '#method_missing' do
    it 'delegates to each of its observers' do
      observers = [double('one'), double('two')]
      observers.each { |observer| allow(observer).to receive(:message) }
      args = double('args')
      composite = CompositeObserver.new(observers)

      composite.message(args)

      observers.each do |observer|
        expect(observer).to have_received(:message).with(args)
      end
    end
  end

  describe '#respond_to?' do
    it 'returns true for Object methods' do
      composite = CompositeObserver.new([])

      expect(composite).to respond_to(:inspect)
    end

    it 'returns true for observer methods' do
      responding = double('one')
      allow(responding).to receive(:message)
      composite = CompositeObserver.new([double('non_responding'), responding])

      expect(composite).to respond_to(:message)
    end

    it 'returns false for undefined methods' do
      composite = CompositeObserver.new([double('non_responding')])

      expect(composite).not_to respond_to(:message)
    end
  end
end
