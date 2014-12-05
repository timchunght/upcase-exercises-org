require "spec_helper"

describe Gitolite::PusherObserver do
  describe "#key_uploaded" do
    it "sends a trigger to pusher" do
      user = double("user", id: "abc")
      stub_channel(user: user) do |channel, channel_factory|
        observer = Gitolite::PusherObserver.new(channel_factory)

        observer.key_uploaded(user_id: user.id)

        expect(channel).to have_received(:trigger).with("uploaded_key")
      end
    end
  end

  def stub_channel(user:)
    channel_factory = double("channel_factory")
    channel = double("channel")
    allow(channel_factory).
      to receive(:new).
      with(user_id: user.id).
      and_return(channel)
    allow(channel).to receive(:trigger)

    yield channel, channel_factory
  end
end
