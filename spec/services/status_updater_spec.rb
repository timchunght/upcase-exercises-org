require "spec_helper"

describe StatusUpdater do
  let(:upcase_client) do
    upcase_client = double("upcase_client")
    allow(upcase_client).to receive(:update_status)
    upcase_client
  end

  def self.it_updates_remote_status(to:)
    it "updates the remote status with #{to}" do
      user = create(:user)
      exercise = double("exercise", uuid: "exercise-uuid")
      status_updater = StatusUpdater.new(
        user: user,
        exercise: exercise,
        upcase_client: upcase_client
      )

      yield status_updater

      expect(upcase_client).
        to have_received(:update_status).with(user, exercise.uuid, to)
    end
  end

  it_updates_remote_status to: "In Progress" do |status_updater|
    status_updater.clone_created
  end

  it_updates_remote_status to: "Complete" do |status_updater|
    status_updater.comment_created("comment")
  end
end
