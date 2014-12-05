# Determine's a User's current state of participation in an exercise and
# provides methods for moving them through the workflow.
class Participation
  pattr_initialize [:exercise, :user, :git_server, :clones]

  def clone
    clones.for_user(user)
  end

  def solution
    clone.flat_map(&:solution)
  end

  def create_clone
    clones.create!(exercise: exercise, user: user, pending: true)
    git_server.create_clone(exercise, user)
  end

  def unpushed?
    !pushed?
  end

  def create_solution
    solution.unwrap_or { clone.unwrap.create_solution! }
  end

  def push_to_clone
    clone.present { |instance| git_server.fetch_diff(instance) }
  end

  def latest_revision
    clone.flat_map(&:latest_revision)
  end

  private

  def pushed?
    clone.fmap(&:revisions).fmap(&:any?).unwrap_or(false)
  end
end
