require 'spec_helper'

describe Git::DiffLine do
  describe '#text' do
    it 'returns the value given during initialization' do
      expect(Git::DiffLine.new(text: 'hello').text).to eq('hello')
    end
  end

  describe '#number' do
    it 'returns the value given during initialization' do
      expect(Git::DiffLine.new(number: 1).number).to eq(1)
    end
  end

  describe '#to_s' do
    context 'for a changed line' do
      it 'returns the line in diff format' do
        line = Git::DiffLine.new(text: 'hello', changed: true)
        expect(line.to_s).to eq('+hello')
      end
    end

    context 'for an unchanged line' do
      it 'returns the line in diff format' do
        line = Git::DiffLine.new(text: 'hello', changed: false)
        expect(line.to_s).to eq(' hello')
      end
    end
  end

  describe '#blank?' do
    context 'with blank text' do
      it 'returns true' do
        expect(Git::DiffLine.new(text: '')).to be_blank
      end
    end

    context 'with present text' do
      it 'returns false' do
        expect(Git::DiffLine.new(text: 'hello')).not_to be_blank
      end
    end
  end

  describe '#changed?' do
    it 'returns the value given during initialization' do
      changed = double('changed')
      expect(Git::DiffLine.new(changed: changed).changed?).to eq(changed)
    end
  end
end
