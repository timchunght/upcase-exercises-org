require "spec_helper"

describe CommentLocator do
  describe "#inline_comments_for" do
    it "filters comments by file name and line number" do
      comments = [
        stub_comment("one", "revision_id:file:line"),
        stub_comment("two", "revision_id:file:line"),
        stub_comment("other_revision", "other_revision_id:file:line"),
        stub_comment("other_file", "revision_id:other_file:line"),
        stub_comment("other_line", "revision_id:file:other_line"),
      ]
      revision = double("revision", id: "revision_id")
      query = CommentLocator.new(comments: comments, revision: revision)

      result = query.inline_comments_for("file", "line")

      expect(result.map(&:text)).to eq(%w(one two))
    end
  end

  describe "#top_level_comments" do
    it "filters for top level comments" do
      comments = [
        stub_comment("one", "top-level"),
        stub_comment("two", "top-level"),
        stub_comment("inline", "revision_id:file:line"),
      ]
      revision = double("revision")
      query = CommentLocator.new(comments: comments, revision: revision)

      result = query.top_level_comments

      expect(result.map(&:text)).to eq(%w(one two))
    end

    it "returns an empty array when none are present" do
      comments = []
      revision = double("revision")
      query = CommentLocator.new(comments: comments, revision: revision)

      result = query.top_level_comments

      expect(result).to eq([])
    end
  end

  describe "#location_for" do
    it "returns the location for a comment" do
      revision = double("revision", id: 2)
      comments = double("comments")
      query = CommentLocator.new(comments: comments, revision: revision)

      location = query.location_for("example.txt", 3)

      expect(location).to eq "2:example.txt:3"
    end
  end

  describe "#location_template_for" do
    it "returns the location template for a file" do
      revision = double("revision", id: 2)
      comments = double("comments")
      query = CommentLocator.new(comments: comments, revision: revision)

      location = query.location_template_for("example.txt")

      expect(location).to eq "2:example.txt:?"
    end
  end

  describe "#create_comment" do
    it "delegates to its comments" do
      create = double("comments.create")
      comment_params = double("comment_params")
      comments = double("comments")
      allow(comments).to receive(:create).and_return(create)
      revision = double("revision")
      locator = CommentLocator.new(comments: comments, revision: revision)

      result = locator.create_comment(comment_params)

      expect(result).to eq(create)
      expect(comments).
        to have_received(:create).with(comment_params)
    end
  end

  def stub_comment(text, location)
    double("comment_#{text}", text: text, location: location)
  end
end
