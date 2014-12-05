class PrioritizedSolutionQuery
  include Enumerable

  pattr_initialize :relation

  def each(&block)
    relation.order([:comments_count, :created_at]).each(&block)
  end
end
