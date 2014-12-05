require "spec_helper"

describe "revisions/_feedback.html.haml" do
  it "does not allow inline comments on old revisions" do
    allow(view).to receive(:current_user).and_return(double(:user))

    render 'revisions/feedback', feedback: stub_feedback

    expect(rendered).not_to match(/\[data\-role\=\'make\-comment\'\]/)
  end

  def stub_feedback
    revision = build_stubbed(:revision)
    allow(revision).to receive(:user).and_return(build_stubbed(:user))
    allow(revision).to receive(:exercise).and_return(build_stubbed(:exercise))
    allow(revision).to receive(:number).and_return(1)

    double(
      "feedback",
      files: [],
      latest_revision?: false,
      viewed_revision: revision,
      revisions: [revision],
      top_level_comments: [],
    )
  end
end
