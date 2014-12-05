class Status::NoSolution
  def to_partial_path
    "statuses/no_solution"
  end

  def applicable?
    true
  end
end
