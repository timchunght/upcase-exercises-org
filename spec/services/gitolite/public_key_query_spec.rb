require "spec_helper"

describe Gitolite::PublicKeyQuery do
  describe "#for" do
    it "returns the public keys for the given user" do
      user = create(:user)
      other_user = create(:user)
      create :public_key, user: user, data: "first"
      create :public_key, user: user, data: "second"
      create :public_key, user: other_user, data: "other"
      query = build_public_key_query

      result = query.for(user)

      expect(result.map(&:data)).to match_array(%w(first second))
    end
  end

  describe "#pending?" do
    context "with pending public keys on its scope" do
      it "returns true" do
        user = create(:user)
        other_user = create(:user)
        create :public_key, pending: true, user: user
        create :public_key, pending: false, user: user
        create :public_key, pending: false, user: other_user
        query = build_public_key_query(relation: user.public_keys)

        expect(query).to be_pending
      end
    end

    context "with no pending public keys on its scope" do
      it "returns false" do
        user = create(:user)
        other_user = create(:user)
        create :public_key, pending: false, user: user
        create :public_key, pending: true, user: other_user
        query = build_public_key_query(relation: user.public_keys)

        expect(query).not_to be_pending
      end
    end
  end

  describe "#clear_pending" do
    context "when the block succeeds" do
      it "marks pending keys from the beginning of the block as complete" do
        preloaded = [
          create(:public_key, pending: true),
          create(:public_key, pending: true)
        ]
        unloaded = nil
        query = build_public_key_query

        query.clear_pending do
          unloaded = create(:public_key, pending: true)
        end

        preloaded.each { |key| expect(key.reload).not_to be_pending }
        expect(unloaded.reload).to be_pending
      end

      it "notifies its observer" do
        first = create(:user)
        second = create(:user)
        no_pending = create(:user)
        no_key = create(:user)
        created_after = create(:user)
        create(:public_key, pending: true, user: first)
        create(:public_key, pending: true, user: first)
        create(:public_key, pending: true, user: second)
        create(:public_key, pending: false, user: second)
        create(:public_key, pending: false, user: no_pending)
        observer = double("observer")
        allow(observer).to receive(:key_uploaded)
        query = build_public_key_query(observer: observer)

        query.clear_pending  do
          create(:public_key, pending: true, user: created_after)
        end

        expect(observer).to have_been_notified_of_key(first.id).once
        expect(observer).to have_been_notified_of_key(second.id).once
        expect(observer).not_to have_been_notified_of_key(no_pending.id)
        expect(observer).not_to have_been_notified_of_key(no_key.id)
        expect(observer).not_to have_been_notified_of_key(created_after.id)
      end
    end

    context "when the block fails" do
      it "re-raises without modifying keys" do
        key = create(:public_key, pending: true)
        exception = StandardError.new("raised")
        query = build_public_key_query

        expect { query.clear_pending { raise exception } }.
          to raise_error(exception)

        expect(key).to be_pending
      end

      it "doesn't notify its observer" do
        create(:public_key, pending: true)
        observer = double("observer")
        allow(observer).to receive(:key_uploaded)
        query = build_public_key_query(observer: observer)

        begin
          query.clear_pending { raise }
        rescue
        end

        expect(observer).not_to have_received(:key_uploaded)
      end
    end
  end

  def have_been_notified_of_key(user_id)
    have_received(:key_uploaded).with(user_id: user_id)
  end

  def build_public_key_query(
    relation: Gitolite::PublicKey.all,
    observer: double("observer", key_uploaded: nil)
  )
    Gitolite::PublicKeyQuery.new(relation: relation, observer: observer)
  end
end
