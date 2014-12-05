require "spec_helper"

describe "mailer/comment.text.erb" do
  before do
    @submitter = build_stubbed(:user)
    @exercise = build_stubbed(:exercise)
    @comment = build_stubbed(:comment)
    @author = build_stubbed(:user)
  end

  context "when recipient is the same as submitter" do
    it "personalizes the message for the author" do
      @recipient = @submitter

      render

      expect(rendered).to include("Your solution to #{@exercise.title}")
    end
  end

  context "when recipient is not the same as submitter" do
    it "personalizes the message for the author" do
      @recipient = build_stubbed(:user)

      render

      expect(rendered).to include(
        "#{@submitter.username}'s solution to #{@exercise.title}"
      )
    end
  end
end
