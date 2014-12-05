require "spec_helper"

describe EventTracker do
  describe "#solution_submitted" do
    it "tracks solution submission" do
      user = double("user", upcase_uid: 1)
      exercise = double("exercise", slug: "an-exercise")
      solution = double("solution")
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.solution_submitted(solution)

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options("Submitted Solution", user, exercise))
    end
  end

  describe "#clone_created" do
    it "tracks clone creation" do
      user = double("user", upcase_uid: 1)
      exercise = double("exercise", slug: "an-exercise")
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.clone_created

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options("Started Exercise", user, exercise))
    end
  end

  describe "#revision_submitted" do
    it "tracks revision submission" do
      user = double("user", upcase_uid: 1)
      exercise = double("exercise", slug: "an-exercise")
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.revision_submitted

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options("Submitted Revision", user, exercise))
    end
  end

  describe "#exercise_visited" do
    it "tracks when a user visits an exercise" do
      user = double("user", upcase_uid: 1)
      exercise = double("exercise", slug: "an-exercise")
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.exercise_visited

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options("Visited Exercise", user, exercise))
    end
  end

  describe "#comment_created" do
    it "tracks user leaving comment and user receiving feedback" do
      user = double("user", upcase_uid: 1)
      exercise = double("exercise", slug: "an-exercise")
      other_user = double("other_user", upcase_uid: 2)
      comment = double("comment", solution_submitter: other_user)
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.comment_created(comment)

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options("Left Comment", user, exercise))
      expect(analytics_backend).
        to have_received(:track).
        with(expected_options("Received Feedback", other_user, exercise))
    end
  end

  def analytics_backend
    @analytics_backend ||= begin
      analytics_backend = double("analytics_backend")
      allow(analytics_backend).to receive(:track)
      analytics_backend
    end
  end

  def expected_options(event_name, user, exercise)
    {
      user_id: user.upcase_uid,
      event: event_name,
      properties: { exercise_slug: exercise.slug },
      integrations: { all: true }
    }
  end
end
