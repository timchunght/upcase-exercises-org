module Gitolite
  class FingerprintedPublicKeyCollection
    pattr_initialize :relation, :fingerprinter

    def new(attributes)
      fingerprint = fingerprinter.fingerprint(attributes[:data])
      relation.new(attributes.merge(fingerprint: fingerprint))
    end

    def exists?(criteria)
      relation.exists?(criteria)
    end
  end
end
