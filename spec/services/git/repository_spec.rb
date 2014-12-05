require "spec_helper"

describe Git::Repository do
  describe "#dsa_fingerprint" do
    it "returns its DSA fingerprint" do
      repository = repo(dsa_fingerprint: "02:12:13")

      expect(repository.dsa_fingerprint).to eq("02:12:13")
    end
  end

  describe "#rsa_fingerprint" do
    it "returns its RSA fingerprint" do
      repository = repo(rsa_fingerprint: "02:12:13")

      expect(repository.rsa_fingerprint).to eq("02:12:13")
    end
  end

  describe "#ecdsa_fingerprint" do
    it "returns its ECDSA fingerprint" do
      repository = repo(ecdsa_fingerprint: "02:12:13")

      expect(repository.ecdsa_fingerprint).to eq("02:12:13")
    end
  end

  describe "#host" do
    it "returns its host" do
      repository = repo(host: "example.com")

      expect(repository.host).to eq("example.com")
    end
  end

  describe "#name" do
    it "returns the last component of its path" do
      repository = repo(path: "path/to/repo")

      expect(repository.name).to eq("repo")
    end
  end

  describe "#path" do
    it "returns its path" do
      repository = repo(path: "some/path")

      expect(repository.path).to eq("some/path")
    end
  end

  describe "#url" do
    it "uses the host and path to generate a full Git URL" do
      repository = repo(host: "example.com", path: "user/repo")

      url = repository.url

      expect(url).to eq("git@example.com:user/repo.git")
    end
  end

  def repo(
    host: "example.com",
    path: "user/repo",
    dsa_fingerprint: "b5:64:af:b5:07:98:23:c9:e2:38:fc:cd:cf:f7:69:57",
    rsa_fingerprint: "c6:1a:c2:61:98:bf:04:0e:80:82:d8:69:94:ee:f6:9a",
    ecdsa_fingerprint: "84:9b:40:53:78:a6:2a:94:61:8f:9c:b7:87:53:2e:f6"
  )
    Git::Repository.new(
      host: host,
      path: path,
      dsa_fingerprint: dsa_fingerprint,
      rsa_fingerprint: rsa_fingerprint,
      ecdsa_fingerprint: ecdsa_fingerprint
    )
  end
end
