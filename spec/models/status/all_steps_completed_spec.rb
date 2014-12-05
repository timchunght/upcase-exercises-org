require 'spec_helper'

describe Status::AllStepsCompleted do
  describe '#applicable?' do
    it 'delegates to the feedback progress' do
      expected = double('expected')
      progressing_user = double('progressing_user')
      allow(progressing_user).
        to receive(:has_given_and_received_review?).
        and_return(expected)
      status = build_status(progressing_user: progressing_user)

      result = status.applicable?

      expect(result).to eq(expected)
    end
  end

  describe "#reviewer_username" do
    it "returns reviewer's username" do
      status = build_status(reviewer: double(username: "jdoe"))

      expect(status.reviewer_username).to eq "jdoe"
    end
  end

  describe "#reviewer_avatar_url" do
    it "returns reviewer's avatar_url" do
      status = build_status(reviewer: double(avatar_url: "URL"))

      expect(status.reviewer_avatar_url).to eq "URL"
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      status = build_status

      result = status.to_partial_path

      expect(result).to eq('statuses/all_steps_completed')
    end
  end

  def build_status(
    progressing_user: double(:progressing_user),
    reviewer: double(:reviewer)
  )
    Status::AllStepsCompleted.new(
      progressing_user: progressing_user,
      reviewer: reviewer.wrapped
    )
  end
end
