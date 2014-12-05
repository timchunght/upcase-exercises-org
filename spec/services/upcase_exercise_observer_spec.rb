require "spec_helper"

describe Upcase::ExerciseObserver do
  describe "#saved" do
    it "updates exercise on Upcase" do
      exercise = build_stubbed(:exercise)
      upcase_client = double("upcase_client", synchronize_exercise: true)
      observer = build_observer(upcase_client: upcase_client)

      observer.saved(exercise)

      expect(upcase_client).
        to have_received(:synchronize_exercise).with(
          edit_url: "EDIT_URL",
          summary: exercise.summary,
          title: exercise.title,
          url: "URL",
          uuid: exercise.uuid
        )
    end
  end

  describe "#created" do
    it "doesn't raise an error" do
      observer = build_observer

      expect { observer.updated(double("exercise")) }.not_to raise_error
    end
  end

  describe "#updated" do
    it "doesn't raise an error" do
      observer = build_observer

      expect { observer.updated(double("exercise")) }.not_to raise_error
    end
  end

  def build_observer(upcase_client: double("upcase_client"))
    url_helper = double(
      "url_helper",
      edit_admin_exercise_url: "EDIT_URL",
      exercise_url: "URL"
    )
    Upcase::ExerciseObserver.new(
      upcase_client: upcase_client,
      url_helper: url_helper
    )
  end
end
