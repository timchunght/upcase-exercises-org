require "spec_helper"

describe Git::ExerciseObserver do
  describe "#created" do
    it "notifies the Git server" do
      exercise = double("exercise", slug: double("slug"))
      server = double("server")
      allow(server).to receive(:create_exercise)
      observer = build_observer(server: server)

      observer.created(exercise)

      expect(server).to have_received(:create_exercise).with(exercise.slug)
    end
  end

  describe "#updated" do
    it "doesn't raise an error" do
      observer = build_observer

      expect { observer.updated(double("exercise")) }.not_to raise_error
    end
  end

  describe "#saved" do
    it "doesn't raise an error" do
      observer = build_observer

      expect { observer.saved(double("exercise")) }.not_to raise_error
    end
  end

  def build_observer(server: double("server"))
    Git::ExerciseObserver.new(server)
  end
end
