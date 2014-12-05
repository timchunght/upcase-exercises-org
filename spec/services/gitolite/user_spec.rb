require "spec_helper"

describe Gitolite::User do
  it "decorates its user" do
    user = double("user", username: "willy")
    gitolite_user = Gitolite::User.new(user, public_keys: double("public_keys"))

    result = gitolite_user.username

    expect(gitolite_user).to be_a(SimpleDelegator)
    expect(result).to eq("willy")
  end

  describe "#has_pending_public_keys?" do
    it "delegates to its public_keys" do
      expected = double("public_keys.pending?")
      user = double("user")
      public_keys = double("public_keys", pending?: expected)
      gitolite_user = Gitolite::User.new(user, public_keys: public_keys)

      result = gitolite_user.has_pending_public_keys?

      expect(result).to eq(expected)
    end
  end
end
