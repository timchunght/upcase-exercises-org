class ObservingParticipation < SimpleDelegator
  def initialize(participation, observer)
    super(participation)
    @observer = observer
  end

  def create_clone
    super
    observer.clone_created
  end

  def create_solution
    solution = super
    observer.solution_submitted(solution)
  end

  def push_to_clone
    super
    observer.revision_submitted
  end

  private

  attr_reader :observer
end
