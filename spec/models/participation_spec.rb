require "spec_helper"

describe Participation do
  describe "#clone" do
    it "delegates to its clones" do
      existing_clone = build_stubbed(:clone)
      user = build_stubbed(:user)
      participation =
        build_participation(existing_clone: existing_clone, user: user)

      result = participation.clone

      expect(result).to eq(existing_clone.wrapped)
    end
  end

  describe "#create_clone" do
    it "create pending clone object and tell Git server to clone an exercise" do
      exercise = build_stubbed(:exercise)
      user = build_stubbed(:user)
      git_server = double("git_server")
      allow(git_server).to receive(:create_clone)
      clones = double("clones", create!: true)
      participation = build_participation(
        exercise: exercise,
        user: user,
        git_server: git_server,
        clones: clones
      )

      participation.create_clone

      expect(git_server).to have_received(:create_clone).with(exercise, user)
      expect(clones).to have_received(:create!).with(
        exercise: exercise,
        user: user,
        pending: true
      )
    end
  end

  describe "#create_solution" do
    context "with an existing clone and an existing solution" do
      it "doesn't create a solution" do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        allow(existing_clone).
          to receive(:solution).
          and_return(existing_solution.wrapped)
        allow(existing_clone).to receive(:create_solution!)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        participation.create_solution

        expect(existing_clone).not_to have_received(:create_solution!)
      end
    end

    context "with an existing clone and no existing solution" do
      it "creates a new solution" do
        existing_clone = build_stubbed(:clone)
        allow(existing_clone).to receive(:solution).and_return(nil.wrapped)
        allow(existing_clone).to receive(:create_solution!)
        participation = build_participation(existing_clone: existing_clone)

        participation.create_solution

        expect(existing_clone).to have_received(:create_solution!)
      end
    end

    context "with no existing clone" do
      it "raises an exception" do
        participation = build_participation(existing_clone: nil)

        expect { participation.create_solution }.to raise_error(IndexError)
      end
    end
  end

  describe "#solution" do
    context "with an existing clone" do
      it "delegates to its clone" do
        existing_clone = build_stubbed(:clone)
        existing_solution = build_stubbed(:solution)
        allow(existing_clone).
          to receive(:solution).
          and_return(existing_solution)
        user = build_stubbed(:user)
        participation =
          build_participation(existing_clone: existing_clone, user: user)

        result = participation.solution

        expect(result).to eq(existing_solution)
      end
    end

    context "with no existing clone" do
      it "returns blank" do
        user = build_stubbed(:user)
        participation = build_participation(user: user)

        expect(participation.solution).to be_blank
      end
    end
  end

  describe "#latest_revision" do
    context "with an existing clone" do
      it "delegates to the clones's latest revision" do
        revision = double("clone.latest_revision")
        clone = build_stubbed(:clone)
        allow(clone).to receive(:latest_revision).and_return(revision)
        participation = build_participation(
          existing_clone: clone
        )

        expect(participation.latest_revision).to eq(revision)
      end
    end

    context "without an existing clone" do
      it "returns a blank" do
        participation = build_participation(existing_clone: nil)
        expect(participation.latest_revision).to be_blank
      end
    end
  end

  describe "#push_to_clone" do
    context "with an existing clone" do
      it "updates existing solution" do
        clone = build_stubbed(:clone)
        git_server = stub_git_server(clone: clone)
        participation = build_participation(
          existing_clone: clone,
          git_server: git_server
        )

        participation.push_to_clone

        expect(git_server).to have_received(:fetch_diff).with(clone)
      end
    end

    context "with no existing clone" do
      it "does nothing" do
        git_server = stub_git_server
        participation = build_participation(git_server: git_server)

        participation.push_to_clone

        expect(git_server).not_to have_received(:fetch_diff)
      end
    end
  end

  describe "#unpushed?" do
    context "with no clone" do
      it "returns true" do
        participation = build_participation(existing_clone: nil)

        expect(participation).to be_unpushed
      end
    end

    context "with a clone but no revisions" do
      it "returns true" do
        clone = build_stubbed(:clone)
        allow(clone.revisions).to receive(:any?).and_return(false)
        participation = build_participation(existing_clone: clone)

        expect(participation).to be_unpushed
      end
    end

    context "with a clone and revisions" do
      it "returns false" do
        clone = build_stubbed(:clone)
        allow(clone.revisions).to receive(:any?).and_return(true)
        participation = build_participation(existing_clone: clone)

        expect(participation).not_to be_unpushed
      end
    end
  end

  def stub_git_server(options = {})
    double("git_server").tap do |git_server|
      allow(git_server).
        to receive(:fetch_diff).
        with(options[:clone]).
        and_return(options[:diff] || "diff")
    end
  end

  def build_participation(
    clones: double("clones"),
    exercise: build_stubbed(:exercise),
    existing_clone: nil,
    git_server: double(:git_server),
    user: build_stubbed(:user)
  )
    allow(clones).
      to receive(:for_user).
      with(user).
      and_return(existing_clone.wrapped)

    Participation.new(
      exercise: exercise,
      git_server: git_server,
      user: user,
      clones: clones
    )
  end
end
