module RevisionsHelper
  def revision_or_solution_url(revision)
    if revision.latest?
      exercise_solution_url(revision.exercise, revision.user)
    else
      exercise_solution_revision_url(
        revision.exercise,
        revision.user,
        revision.number
      )
    end
  end
end
