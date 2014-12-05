class StatusUpdater
  pattr_initialize [:user!, :exercise!, :upcase_client!]

  def clone_created
    update_with("In Progress")
  end

  def revision_submitted
  end

  def solution_submitted(_solution)
  end

  def comment_created(_comment)
    update_with("Complete")
  end

  private

  def update_with(state)
    upcase_client.update_status(user, exercise.uuid, state)
  end
end
