# Determines solutions to display in the solutions list on the review page.
class ReviewableSolutionsQuery
  pattr_initialize([
    :solutions!,
    :submitted_solution,
    :viewed_solution!
  ])

  attr_reader :submitted_solution, :viewed_solution

  def solutions_by_other_users
    solutions.to_a - submitted_solution.to_a
  end

  def assigned_solution
    solutions_by_other_users.first || submitted_solution.unwrap
  end

  def assigned_solver
    assigned_solution.user
  end

  def user_has_solution?
    submitted_solution.present?
  end

  def solution_reviewer
    submitted_solution.flat_map(&:first_commenter)
  end
end
