class SubscriptionObserver
  pattr_initialize :user

  def solution_submitted(solution)
    create_subscription(solution)
  end

  def comment_created(comment)
    create_subscription(comment.solution)
  end

  def clone_created
  end

  def revision_submitted
  end

  private

  def create_subscription(solution)
    Subscription.find_or_create_by!(solution: solution, user: user)
  end
end
