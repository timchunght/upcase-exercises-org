require "spec_helper"

describe CommentableLine do
  include Rails.application.routes.url_helpers

  it "decorates diff line" do
    diff_line = double("diff_line", foo: nil)
    commentable_line = CommentableLine.new(diff_line, double)

    commentable_line.foo

    expect(diff_line).to have_received(:foo)
  end

  describe "#comments" do
    it "makes calls to the comment query object" do
      diff_line = double("diff_line", number: 1, file_name: "foo")
      comment_locator = double("comment_locator", inline_comments_for: nil)
      line = CommentableLine.new(diff_line, comment_locator)

      line.comments

      expect(comment_locator).to have_received(:inline_comments_for).
        with(diff_line.file_name, diff_line.number)
    end
  end

  describe "#location" do
    it "returns line location" do
      diff_line = double(
        "diff_line",
        number: double("diff_line.number"),
        file_name: double("diff_line.file_name")
      )
      location = double("comment_locator.location_for")
      comment_locator = double("comment_locator")
      allow(comment_locator).to receive(:location_for).
        with(diff_line.file_name, diff_line.number).
        and_return(location)
      line = CommentableLine.new(diff_line, comment_locator)

      result = line.location

      expect(result).to eq(location)
    end
  end
end
