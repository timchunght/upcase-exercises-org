require "spec_helper"

describe Git::CloneObserver do
  describe "#clone_created" do
    it "updates a local record of the clone" do
      sha = "abc123"
      exercise = build_stubbed(:exercise)
      user = build_stubbed(:user)
      clone = double("clone", update_attributes!: true)
      clones = double("clones", find_by!: clone)
      observer = Git::CloneObserver.new(clones: clones)

      result = observer.clone_created(exercise, user, sha)

      expect(result).to eq(clone)
      expect(clones).to have_received(:find_by!).with(
        exercise_id: exercise.id,
        user_id: user.id
      )
      expect(clone).to have_received(:update_attributes!).with(
        parent_sha: sha,
        pending: false
      )
    end
  end

  describe "#diff_fetched" do
    it "creates a new revision" do
      diff = "--- +++"
      clone = double("clone")
      allow(clone).to receive(:create_revision!)
      observer = Git::CloneObserver.new(clones: double("clones"))

      observer.diff_fetched(clone, diff)

      expect(clone).to have_received(:create_revision!).with(diff: diff)
    end
  end
end
