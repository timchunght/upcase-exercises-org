class Status::AwaitingReview
  pattr_initialize :progressing_user

  def applicable?
    progressing_user.has_reviewed_other_solution? &&
      progressing_user.awaiting_review?
  end

  def to_partial_path
    'statuses/awaiting_review'
  end
end
