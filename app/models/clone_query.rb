# Finds and creates clones for exercises and users.
class CloneQuery
  pattr_initialize :relation

  def for_user(user)
    relation.find_by(user_id: user.id).wrapped
  end

  def create!(attributes)
    relation.create!(attributes)
  end
end
