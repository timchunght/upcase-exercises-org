require 'spec_helper'

describe Status::SubmittedSolution do
  describe "#to_partial_path" do
    it "returns a string" do
      status = build_status

      result = status.to_partial_path

      expect(result).to eq("statuses/submitted_solution")
    end
  end

  describe "#applicable?" do
    context "when the user has a solution" do
      it "returns true" do
        solutions =  double("solutions", user_has_solution?: true)
        status = build_status(solutions: solutions)

        result = status.applicable?

        expect(result).to be_truthy
      end
    end

    context "when the user has no solution" do
      it "returns false" do
        solutions =  double("solutions", user_has_solution?: false)
        status = build_status(solutions: solutions)

        result = status.applicable?

        expect(result).to be_falsey
      end
    end
  end

  describe "#assigned_solution" do
    it "delegates to its solutions" do
      solutions = double(
        :solutions,
        assigned_solution: double(:assigned_solution)
      )
      status = build_status(solutions: solutions)

      expect(status.assigned_solution).to eq(solutions.assigned_solution)
    end
  end

  def build_status(solutions: double(:solutions))
    Status::SubmittedSolution.new(solutions)
  end
end
