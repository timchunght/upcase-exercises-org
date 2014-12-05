require "spec_helper"

describe Feedback do
  describe "#revisions" do
    it "returns revisions" do
      revisions = double(:revisions)
      feedback = build_feedback(revisions: revisions)

      result = feedback.revisions

      expect(result).to eq(revisions)
    end
  end

  describe "#files" do
    it "delegates to its viewed revision" do
      files = double(:files)
      viewed_revision = double(:viewed_revision, files: files)
      feedback = build_feedback(viewed_revision: viewed_revision)

      result = feedback.files

      expect(result).to eq(files)
    end
  end

  describe "#viewed_revision" do
    it "returns the viewed revision" do
      viewed_revision = double(:viewed_revision)
      feedback = build_feedback(viewed_revision: viewed_revision)

      result = feedback.viewed_revision

      expect(result).to eq(viewed_revision)
    end
  end

  describe "#latest_revision?" do
    it "delegates to its viewed revision" do
      latest_revision = double("latest_revision")
      viewed_revision = double(:viewed_revision, latest?: latest_revision)
      feedback = build_feedback(viewed_revision: viewed_revision)

      result = feedback.latest_revision?

      expect(result).to eq(latest_revision)
    end
  end

  describe "#top_level_comments" do
    it "delegates to its comment locator" do
      top_level_comments = double("comment_locator.top_level_comments")
      comment_locator = double("comment_locator")
      allow(comment_locator).
        to receive(:top_level_comments).
        and_return(top_level_comments)
      feedback = build_feedback(comment_locator: comment_locator)

      result = feedback.top_level_comments

      expect(result).to eq(top_level_comments)
    end
  end

  describe "#create_comment" do
    it "delegates to its comment locator" do
      create_comment = double("comment_locator.create_comment")
      comment_params = double("comment_params")
      comment_locator = double("comment_locator")
      allow(comment_locator).
        to receive(:create_comment).
        and_return(create_comment)
      feedback = build_feedback(comment_locator: comment_locator)

      result = feedback.create_comment(comment_params)

      expect(result).to eq(create_comment)
      expect(comment_locator).
        to have_received(:create_comment).with(comment_params)
    end
  end

  def build_feedback(
    comment_locator: double("comment_locator"),
    revisions: double("revisions"),
    viewed_revision: double("viewed_revision")
  )
    Feedback.new(
      comment_locator: comment_locator,
      revisions: revisions,
      viewed_revision: viewed_revision
    )
  end
end
