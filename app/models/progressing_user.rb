# Query methods for a user's commenting actions in a review.
class ProgressingUser
  pattr_initialize [:exercise!, :user!, :submitted_solution]

  def has_submitted_solution?
    submitted_solution.present?
  end

  def awaiting_review?
    submitted_solution.fmap(&:has_comments?).fmap(&:!).unwrap_or(false)
  end

  def has_reviewed_other_solution?
    exercise.has_comments_from?(user)
  end

  def has_received_review?
    submitted_solution.fmap(&:has_comments?).unwrap_or(false)
  end

  def has_given_and_received_review?
    has_reviewed_other_solution? && has_received_review?
  end
end
