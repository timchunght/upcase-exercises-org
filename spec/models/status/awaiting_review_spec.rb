require 'spec_helper'

describe Status::AwaitingReview do
  describe '#applicable?' do
    context "if user has performed a review but are awaiting review" do
      it "returns true" do
        progressing_user = double('progressing_user')
        allow(progressing_user).
          to receive(:has_reviewed_other_solution?).
          and_return(true)
        allow(progressing_user).to receive(:awaiting_review?).and_return(true)

        result = build_status(progressing_user).applicable?

        expect(result).to be_truthy
      end
    end

    context "if the user has not reviewed their other solution" do
      it "returns false" do
        progressing_user = double('progressing_user')
        allow(progressing_user).
          to receive(:has_reviewed_other_solution?).
          and_return(false)
        allow(progressing_user).to receive(:awaiting_review?).and_return(true)

        result = build_status(progressing_user).applicable?

        expect(result).to be_falsey
      end
    end

    context "if the user has already received a review" do
      it "returns false" do
        progressing_user = double('progressing_user')
        allow(progressing_user).
          to receive(:has_reviewed_other_solution?).
          and_return(true)
        allow(progressing_user).to receive(:awaiting_review?).and_return(false)

        result = build_status(progressing_user).applicable?

        expect(result).to be_falsey
      end
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      progressing_user = double('progressing_user')

      result = build_status(progressing_user).to_partial_path

      expect(result).to eq('statuses/awaiting_review')
    end
  end

  def build_status(progressing_user)
    Status::AwaitingReview.new(progressing_user)
  end
end
