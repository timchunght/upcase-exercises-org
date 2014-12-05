require "spec_helper"

describe Status::NoSolution do
  describe "#to_partial_path" do
    it "returns a string" do
      status = Status::NoSolution.new

      result = status.to_partial_path

      expect(result).to eq("statuses/no_solution")
    end
  end

  describe "#applicable?" do
    it "returns true" do
      status = Status::NoSolution.new

      expect(status).to be_applicable
    end
  end
end
