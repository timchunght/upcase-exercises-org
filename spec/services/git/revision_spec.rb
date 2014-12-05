require "spec_helper"

describe Git::Revision do
  it "delegates attributes to its revision" do
    revision = build_stubbed(:revision)
    git_revision = Git::Revision.new(revision, double("parser_factory"))

    expect(git_revision.diff).to eq(revision.diff)
    expect(git_revision).to be_a(SimpleDelegator)
  end

  describe "#files" do
    it "delegates to a diff parser" do
      diff = "diff example.txt"
      files = double("files")
      parser = double("parser", parse: files)
      parser_factory = double("parser_factory")
      allow(parser_factory).to receive(:new).with(diff: diff).and_return(parser)
      revision = build_stubbed(:revision, diff: diff)
      git_revision = Git::Revision.new(revision, parser_factory)

      result = git_revision.files

      expect(result).to eq(files)
    end
  end
end
