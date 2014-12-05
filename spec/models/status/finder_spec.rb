require 'spec_helper'

describe Status::Finder do
  describe '#find' do
    it 'returns the highest priority status' do
      candidates = [
        double('a', applicable?: false),
        double('b', applicable?: true),
        double('c', applicable?: true),
      ]
      finder = Status::Finder.new(candidates)

      result = finder.find

      expect(result).to eq(candidates[1])
    end
  end
end
