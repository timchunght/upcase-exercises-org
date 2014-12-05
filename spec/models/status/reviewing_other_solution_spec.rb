require "spec_helper"

describe Status::ReviewingOtherSolution do
  describe "#applicable?" do
    context "when the reviewer has a solution and views another solution" do
      it "returns true" do
        solutions = double(
          "solutions",
          submitted_solution: double("submitted_solution").wrapped,
          viewed_solution: double("viewed_solution"),
          user_has_solution?: true
        )

        status = Status::ReviewingOtherSolution.new(solutions)

        expect(status).to be_applicable
      end
    end

    context "when viewing the submitted solution" do
      it "returns false" do
        solution = double("solution")
        solutions = double(
          "solutions",
          submitted_solution: solution.wrapped,
          viewed_solution: solution,
          user_has_solution?: true
        )
        status = Status::ReviewingOtherSolution.new(solutions)

        expect(status).not_to be_applicable
      end
    end

    context "when the reviewer has no solution" do
      it "returns false" do
        solutions = double(
          "solutions",
          submitted_solution: nil.wrapped,
          user_has_solution?: false,
          viewed_solution: double("viewed_solution")
        )
        status = Status::ReviewingOtherSolution.new(solutions)

        expect(status).not_to be_applicable
      end
    end
  end

  describe "#assigned_solution" do
    it "delegates to its solutions" do
      solutions = double(
        "solutions",
        assigned_solution: double("assigned_solution"),
      )
      status = Status::ReviewingOtherSolution.new(solutions)

      expect(status.assigned_solution).to eq(solutions.assigned_solution)
    end
  end

  describe "#submitted_solution" do
    it "unwraps from its solutions" do
      submitted_solution = double("submitted_solution")
      solutions = double(
        "solutions",
        submitted_solution: submitted_solution.wrapped,
      )
      status = Status::ReviewingOtherSolution.new(solutions)

      expect(status.submitted_solution).to eq(submitted_solution)
    end
  end

  describe "#to_partial_path" do
    it "returns a string" do
      status = Status::ReviewingOtherSolution.new(double("solutions"))
      result = status.to_partial_path

      expect(result).to eq("statuses/reviewing_other_solution")
    end
  end
end
