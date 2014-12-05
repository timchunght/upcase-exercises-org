class ExercisesController < ApplicationController
  def show
    @overview = dependencies[:current_overview]
    track_exercise_visit
  end

  private

  def track_exercise_visit
    event_tracker.exercise_visited
  end

  def event_tracker
    dependencies[:event_tracker_factory].new(
      user: current_user,
      exercise: dependencies[:requested_exercise]
    )
  end
end
