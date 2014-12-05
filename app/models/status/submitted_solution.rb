class Status::SubmittedSolution
  pattr_initialize :solutions

  delegate :assigned_solution, to: :solutions

  def applicable?
    solutions.user_has_solution?
  end

  def to_partial_path
    'statuses/submitted_solution'
  end
end
