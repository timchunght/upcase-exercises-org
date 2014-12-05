module Git
  # Value object for a Git repository.
  class Repository
    include ActiveModel::Conversion

    def initialize(attributes)
      @host = attributes[:host]
      @path = attributes[:path]
      @dsa_fingerprint = attributes[:dsa_fingerprint]
      @rsa_fingerprint = attributes[:rsa_fingerprint]
      @ecdsa_fingerprint = attributes[:ecdsa_fingerprint]
    end

    def name
      File.basename(path)
    end

    def url
      "git@#{host}:#{path}.git"
    end

    attr_reader \
      :dsa_fingerprint,
      :ecdsa_fingerprint,
      :host,
      :path,
      :rsa_fingerprint
  end
end
