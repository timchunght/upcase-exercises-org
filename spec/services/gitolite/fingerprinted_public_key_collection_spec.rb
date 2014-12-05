require 'spec_helper'

describe Gitolite::FingerprintedPublicKeyCollection do
  describe '#new' do
    it 'adds a fingerprint to the data' do
      data = double('data')
      key = double('key')
      fingerprint = double('fingerprint')
      relation = double('relation')
      allow(relation).to receive(:new).and_return(key)
      fingerprinter = double('fingerprinter')
      allow(fingerprinter).
        to receive(:fingerprint).
        with(data).
        and_return(fingerprint)
      collection = Gitolite::FingerprintedPublicKeyCollection.new(
        relation,
        fingerprinter
      )

      result = collection.new(data: data)

      expect(relation).to have_received(:new).
        with(data: data, fingerprint: fingerprint)
      expect(result).to eq(key)
    end
  end

  describe '#exists?' do
    it 'delegates to its relation' do
      criteria = double('criteria')
      value = double('relation.exists?(criteria)')
      relation = double('relation')
      allow(relation).to receive(:exists?).with(criteria).and_return(value)
      fingerprinter = double('fingerprinter')
      collection =
        Gitolite::FingerprintedPublicKeyCollection.new(relation, fingerprinter)

      result = collection.exists?(criteria)

      expect(result).to eq(value)
    end
  end
end
