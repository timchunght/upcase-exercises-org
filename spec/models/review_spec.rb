require "spec_helper"

describe Review do
  describe "#exercise" do
    it "returns its exercise" do
      exercise = double("exercise")
      review = build_review(exercise: exercise)

      result = review.exercise

      expect(result).to eq(exercise)
    end
  end

  describe "#feedback" do
    it "returns its feedback" do
      feedback = double("feedback")
      review = build_review(feedback: feedback)

      result = review.feedback

      expect(result).to eq(feedback)
    end
  end

  describe "#progress" do
    it "returns its progress" do
      progress = double("progress")
      review = build_review(progress: progress)

      result = review.progress

      expect(result).to eq(progress)
    end
  end

  describe "#solutions" do
    it "returns its solutions" do
      solutions = double("solutions")
      review = build_review(solutions: solutions)

      result = review.solutions

      expect(result).to eq(solutions)
    end
  end

  describe "#status" do
    it "returns the status given when initialized" do
      status = double("status")
      review = build_review(status: status)

      result = review.status

      expect(result).to eq(status)
    end
  end

  def build_review(
    exercise: double("exercise"),
    feedback: double("feedback"),
    progress: double("progress"),
    solutions: double("solutions"),
    status: double("status")
  )
    Review.new(
      exercise: exercise,
      feedback: feedback,
      progress: progress,
      solutions: solutions,
      status: status,
    )
  end
end
