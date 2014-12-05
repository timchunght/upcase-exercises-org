class Status::AllStepsCompleted
  pattr_initialize [:progressing_user!, :reviewer!]

  def applicable?
    progressing_user.has_given_and_received_review?
  end

  def reviewer_username
    reviewer.unwrap.username
  end

  def reviewer_avatar_url
    reviewer.unwrap.avatar_url
  end

  def to_partial_path
    "statuses/all_steps_completed"
  end
end
