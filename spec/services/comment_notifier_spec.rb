require "spec_helper"

describe CommentNotifier do
  describe "#comment_created" do
    it "delivers a new comment notification" do
      subscriber = double("subscriber")
      comment = double("comment")
      allow(comment).to receive(:subscribers).and_return([subscriber])
      notification = double("notification")
      allow(notification).to receive(:deliver)
      notification_factory = double("factory")
      allow(notification_factory).
        to receive(:new).
        with(comment: comment, recipient: subscriber).
        and_return(notification)
      comment_notifier = CommentNotifier.new(notification_factory)

      comment_notifier.comment_created(comment)

      expect(notification).to have_received(:deliver)
    end
  end
end
