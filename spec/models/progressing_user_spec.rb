require "spec_helper"

describe ProgressingUser do
  describe "#has_submitted_solution?" do
    context "when the user has submitted a solution" do
      context "and the user's solution has no comments" do
        it "returns true" do
          progress =
            build_progress(submitted_solution: stub_solution_without_comments)

          expect(progress).to have_submitted_solution
        end
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        progress = build_progress(submitted_solution: nil)

        expect(progress).not_to have_submitted_solution
      end
    end
  end

  describe "#awaiting_review?" do
    context "when the user has submitted a solution" do
      context "and the user's solution has no comments" do
        it "returns true" do
          progress =
            build_progress(submitted_solution: stub_solution_without_comments)

          expect(progress).to be_awaiting_review
        end
      end

      context "and the user's solution has comments" do
        it "returns false" do
          progress =
            build_progress(submitted_solution: stub_solution_with_comments)

          expect(progress).not_to be_awaiting_review
        end
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        progress = build_progress(submitted_solution: nil)

          expect(progress).not_to be_awaiting_review
      end
    end
  end

  describe "#has_reviewed_other_solution?" do
    context "when the user has commented on another solution" do
      it "returns true" do
        user = double("user")
        exercise = stub_exercise_with_comments_from(user)

        progress = build_progress(user: user, exercise: exercise)

        expect(progress).to have_reviewed_other_solution
      end
    end

    context "when the user has not commend on another solution" do
      it "returns false" do
        user = double("user")
        exercise = stub_exercise_without_comments

        progress = build_progress(
          user: user,
          exercise: exercise,
        )

        expect(progress).not_to have_reviewed_other_solution
      end
    end
  end

  describe "#has_received_review?" do
    context "when the user has received a review" do
      it "returns true" do
        user = double("user")
        submitted_solution = stub_solution_with_comments
        exercise = stub_exercise_without_comments

        progress = build_progress(
          exercise: exercise,
          user: user,
          submitted_solution: submitted_solution,
        )

        expect(progress).to have_received_review
      end
    end

    context "when the user has not receieved a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution_without_comments
        exercise = stub_exercise_without_comments

        progress = build_progress(
          exercise: exercise,
          user: user,
          submitted_solution: submitted_solution,
        )

        expect(progress).not_to have_received_review
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        user = double("user")
        exercise = stub_exercise_without_comments

        progress = build_progress(
          submitted_solution: nil,
          user: user,
          exercise: exercise,
        )

        expect(progress).not_to have_received_review
      end
    end
  end

  describe "#has_given_and_received_review?" do
    context "when the user has given and received a review" do
      it "returns true" do
        user = double("user")
        submitted_solution = stub_solution_with_comments
        exercise = stub_exercise_with_comments_from(user)

        progress = build_progress(
          exercise: exercise,
          user: user,
          submitted_solution: submitted_solution,
        )

        expect(progress).to have_given_and_received_review
      end
    end

    context "when the user has not given a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution_with_comments
        exercise = stub_exercise_without_comments

        progress = build_progress(
          exercise: exercise,
          user: user,
          submitted_solution: submitted_solution,
        )

        expect(progress).not_to have_given_and_received_review
      end
    end

    context "when the user has not receieved a review" do
      it "returns false" do
        user = double("user")
        submitted_solution = stub_solution_without_comments
        exercise = stub_exercise_without_comments

        progress = build_progress(
          exercise: exercise,
          user: user,
          submitted_solution: submitted_solution,
        )

        expect(progress).not_to have_given_and_received_review
      end
    end

    context "when the user has not submitted a solution" do
      it "returns false" do
        user = double("user")
        exercise = stub_exercise_without_comments

        progress = build_progress(
            submitted_solution: nil,
            user: user,
            exercise: exercise,
          )

        expect(progress).not_to have_given_and_received_review
      end
    end
  end

  def stub_exercise_with_comments_from(user)
    double("exercise").tap do |exercise|
      allow(exercise).
        to receive(:has_comments_from?).
        with(user).
        and_return(true)
    end
  end

  def stub_exercise_without_comments
    double("exercise", has_comments_from?: false)
  end

  def stub_solution_with_comments
    double("solution_with_comments", has_comments?: true)
  end

  def stub_solution_without_comments
    double("no_comments_solution", has_comments?: false)
  end

  def build_progress(
    submitted_solution: double("submitted_solution"),
    exercise: double("exercise"),
    user: double("user")
  )
    ProgressingUser.new(
      submitted_solution: submitted_solution.wrapped,
      exercise: exercise,
      user: user
    )
  end
end
