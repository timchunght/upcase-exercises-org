require "spec_helper"

describe SubscriptionObserver do
  describe "#solution_submitted" do
    it "creates a subscription for solution submitter" do
      allow(Subscription).to receive(:find_or_create_by!)
      solution = double("solution")
      user = double("user")
      observer = SubscriptionObserver.new(user)

      observer.solution_submitted(solution)

      expect(Subscription).
        to have_received(:find_or_create_by!).
        with(solution: solution, user: user)
    end
  end

  describe "#comment_created" do
    it "creates a subscription for commenter" do
      allow(Subscription).to receive(:find_or_create_by!)
      solution = double("solution")
      comment = double("comment", solution: solution)
      user = double("user")
      observer = SubscriptionObserver.new(user)

      observer.comment_created(comment)

      expect(Subscription).
        to have_received(:find_or_create_by!).
        with(solution: solution, user: user)
    end

    it "creates a unique subscription based on solution and user" do
      comment = create(:comment)
      observer = SubscriptionObserver.new(comment.user)

      observer.comment_created(comment)
      observer.comment_created(comment)

      expect(Subscription.count).to eq 1
    end
  end
end
