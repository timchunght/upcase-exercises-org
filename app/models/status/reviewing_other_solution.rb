class Status::ReviewingOtherSolution
  pattr_initialize :solutions
  delegate :assigned_solution, to: :solutions

  def applicable?
    solutions.submitted_solution.
      fmap { |solution| solution != solutions.viewed_solution }.
      unwrap_or(false)
  end

  def submitted_solution
    solutions.submitted_solution.unwrap
  end

  def to_partial_path
    'statuses/reviewing_other_solution'
  end

  private

  def viewing_other_solution?
    solutions.viewed_solution != solutions.submitted_solution
  end
end
