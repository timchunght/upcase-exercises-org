require "spec_helper"

describe Authenticator do
  describe "#authenticate" do
    context "with an existing user" do
      it "finds that user" do
        existing_user = create(:user, upcase_uid: 1)
        auth_hash = build_auth_hash("uid" => 1)

        user = Authenticator.new(auth_hash).authenticate

        expect(user).to eq(existing_user)
      end

      it "updates attributes besides username" do
        existing_user =
          create(:user, upcase_uid: 1, first_name: "old", username: "old")
        auth_hash = build_auth_hash(
          "uid" => 1,
          "info" => {
            "first_name" => "new",
            "username" => "new"
          }
        )

        Authenticator.new(auth_hash).authenticate

        expect(existing_user.reload.first_name).to eq("new")
        expect(existing_user.reload.username).to eq("old")
      end
    end

    context "without an existing user" do
      it "creates a new user" do
        auth_hash = build_auth_hash

        user = Authenticator.new(auth_hash).authenticate

        expect(user).to be_persisted
        expect(user.email).to eq(auth_hash["info"]["email"])
        expect(user.first_name).to eq(auth_hash["info"]["first_name"])
        expect(user.last_name).to eq(auth_hash["info"]["last_name"])
        expect(user.upcase_uid).to eq(auth_hash["uid"])
        expect(user.auth_token).to eq(auth_hash["credentials"]["token"])
        expect(user.admin).to eq(auth_hash["info"]["admin"])
        expect(user.subscriber?).
          to eq(auth_hash["info"]["has_active_subscription"])
        expect(user.username).to eq(auth_hash["info"]["username"])
        expect(user.avatar_url).to eq(auth_hash["info"]["avatar_url"])
      end

      it "ignores invalid usernames" do
        auth_hash = build_auth_hash("info" => { "username" => "" })

        user = Authenticator.new(auth_hash).authenticate

        expect(user).to be_persisted
        expect(user.username).to be_nil
      end
    end

    def build_auth_hash(overrides = {})
      {
        "credentials" => {
          "token" => "abc123"
        },
        "info" => {
          "admin" => true,
          "email" => "user@example.com",
          "first_name" => "Test",
          "has_active_subscription" => true,
          "last_name" => "User",
          "username" => "testuser",
          "avatar_url" => "avatar_url"
        }.merge(overrides["info"] || {}),
        "provider" => "upcase",
        "uid" => 1
      }.merge(overrides.except("info"))
    end
  end
end
