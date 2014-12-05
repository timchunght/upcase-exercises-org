require "spec_helper"

describe Git::PusherObserver do
  describe "#clone_created" do
    it "sends a trigger to pusher" do
      exercise = double("exercise")
      user = double("user", id: "abc")
      stub_channel(user: user) do |channel, channel_factory|
        observer = Git::PusherObserver.new(channel_factory)

        observer.clone_created(exercise, user, double("sha"))

        expect(channel).to have_received(:trigger).with("cloned")
      end
    end
  end

  describe "#diff_fetched" do
    it "sends a trigger to pusher" do
      user = double("user", id: "abc")
      clone = double("clone", user_id: user.id)
      stub_channel(user: user) do |channel, channel_factory|
        observer = Git::PusherObserver.new(channel_factory)

        observer.diff_fetched(clone, double("diff"))

        expect(channel).to have_received(:trigger).with("pushed")
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
