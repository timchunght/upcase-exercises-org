require "spec_helper"

describe ObservingFeedback do
  it "delegates to feedback" do
    feedback = double("feedback", some_method: nil)
    observing_feedback = ObservingFeedback.new(feedback, double)

    observing_feedback.some_method

    expect(feedback).to have_received(:some_method)
  end

  describe "#create_comment" do
    it "notifies its observer and delegates" do
      comment = double("comment")
      comment_params = double("comment_params")
      feedback = double("feedback")
      allow(feedback).
        to receive(:create_comment).
        with(comment_params).
        and_return(comment)
      observer = double("observer")
      allow(observer).to receive(:comment_created)
      observing_feedback =
        ObservingFeedback.new(feedback, observer)

      observing_feedback.create_comment(comment_params)

      expect(observer).to have_received(:comment_created).with(comment)
    end
  end
end
