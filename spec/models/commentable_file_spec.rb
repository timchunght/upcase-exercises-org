require "spec_helper"

describe CommentableFile do
  it "decorates files" do
    diff_file = double("diff_file", name: "example")
    commentable_file = CommentableFile.new(diff_file, double("locator"))

    expect(commentable_file).to be_a(SimpleDelegator)
    expect(commentable_file.name).to eq("example")
  end

  describe "#location_template" do
    it "delegates to its comment locator" do
      template = double("comment_locator.location_template_for")
      diff_file = double("diff_file", name: "example.txt")
      comment_locator = double("comment_locator")
      allow(comment_locator).
        to receive(:location_template_for).
        with(diff_file.name).
        and_return(template)
      commentable_file = CommentableFile.new(diff_file, comment_locator)

      result = commentable_file.location_template

      expect(result).to eq(template)
    end
  end
end
