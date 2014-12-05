require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:solution) }

  it { should validate_presence_of(:text) }

  describe '#solution' do
    it 'caches the number of comments' do
      solution = create(:solution)
      2.times { create(:comment, solution: solution) }

      expect(solution.reload.comments_count).to eq(2)
    end
  end

  describe '#solution_submitter' do
    it 'returns the user who created the solution the comment is attached to' do
      submitter = double('submitter')
      comment = build_stubbed(:comment)
      allow(comment.solution).to receive(:user).and_return(submitter)

      result = comment.solution_submitter

      expect(result).to eq(submitter)
    end
  end

  describe '#exercise' do
    it 'returns the exercise being commented on' do
      exercise = double('exercise')
      comment = build_stubbed(:comment)
      allow(comment.solution).to receive(:exercise).and_return(exercise)

      result = comment.exercise

      expect(result).to eq(exercise)
    end
  end

  describe '.new_top_level' do
    it 'returns a top level comment' do
      comment = Comment.new_top_level

      expect(comment.location).to eq(Comment::TOP_LEVEL)
    end
  end

  describe '#top_level?' do
    context 'with a top level comment' do
      it 'returns true' do
        comment = Comment.new_top_level

        expect(comment).to be_top_level
      end
    end

    context 'with an inline comment' do
      it 'returns false' do
        comment = Comment.new

        expect(comment).not_to be_top_level
      end
    end
  end

  describe "#subscribers" do
    it "delegates to solution" do
      solution = double("solution", subscribers: [])
      comment = build_stubbed(:comment)
      allow(comment).to receive(:solution).and_return(solution)

      expect(comment.subscribers).to eq []
      expect(solution).to have_received(:subscribers)
    end
  end
end
