require "spec_helper"

describe NumberedRevision do
  describe "#number" do
    it "returns the version number" do
      solution = create(:solution)
      with_options(solution: solution) do |with_solution|
        revision = with_solution.create :revision, created_at: 2.day.ago
        with_solution.create :revision, created_at: 1.day.ago
        with_solution.create :revision, created_at: 3.day.ago

        numbered_revision = NumberedRevision.new(revision, solution.revisions)

        expect(numbered_revision.number).to eq 2
      end
    end
  end
end
