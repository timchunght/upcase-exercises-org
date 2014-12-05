class EventTracker
  pattr_initialize :user, :exercise, :analytics_backend

  def solution_submitted(_solution)
    track("Submitted Solution")
  end

  def clone_created
    track("Started Exercise")
  end

  def revision_submitted
    track("Submitted Revision")
  end

  def exercise_visited
    track("Visited Exercise")
  end

  def comment_created(comment)
    track("Left Comment")
    track("Received Feedback", comment.solution_submitter)
  end

  private

  def track(event_name, user = user)
    analytics_backend.track(
      user_id: user.upcase_uid,
      event: event_name,
      properties: { exercise_slug: exercise.slug },
      integrations: { all: true }
    )
  end
end
