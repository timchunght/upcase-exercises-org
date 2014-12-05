require "spec_helper"

describe RevisionsHelper do
  describe "#revision_or_solution_url" do
    context "when the revision is the current revision" do
      it "returns the solution's show url" do
        revision = stub_revision(latest: true)

        result = helper.revision_or_solution_url(revision)

        expect(result).to eq(
          exercise_solution_url(
            revision.exercise,
            revision.user
          )
        )
      end
    end

    context "when the revision is an old revision" do
      it "returns the revision's show url" do
        revision = stub_revision(latest: false)

        result = helper.revision_or_solution_url(revision)

        expect(result).to eq(exercise_solution_revision_url(
          revision.exercise,
          revision.user,
          revision.number)
        )
      end
    end
  end

  def stub_revision(latest:)
    double(
      :revision,
      exercise: build_stubbed(:exercise),
      user: build_stubbed(:user),
      number: 1,
      latest?: latest
    )
  end
end
