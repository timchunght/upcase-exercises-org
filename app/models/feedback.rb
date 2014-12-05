# Represents the portion of the review page which contains files and comments.
class Feedback
  pattr_initialize [:comment_locator!, :revisions!, :viewed_revision!]
  attr_reader :revisions, :viewed_revision

  delegate :files, to: :viewed_revision
  delegate :create_comment, :top_level_comments, to: :comment_locator

  def latest_revision?
    viewed_revision.latest?
  end
end
