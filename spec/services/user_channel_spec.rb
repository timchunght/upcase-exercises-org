require "spec_helper"

describe UserChannel do
  describe "#name" do
    it "generates a name based on the user" do
      pusher = double("pusher")
      user_channel = UserChannel.new(pusher: pusher, user_id: "123")

      result = user_channel.name

      expect(result).to eq("user.123")
    end
  end

  describe "#trigger" do
    it "pushes to a pusher channel with its name" do
      pusher = double("pusher")
      channel = double("channel")
      event = double("event")
      user_channel = UserChannel.new(pusher: pusher, user_id: "123")
      allow(pusher).to receive(:[]).with(user_channel.name).and_return(channel)
      allow(channel).to receive(:trigger)

      user_channel.trigger(event)

      expect(channel).to have_received(:trigger).with(event, UserChannel::DATA)
    end
  end
end
