module Git
  class CloneObserver
    pattr_initialize [:clones!]

    def clone_created(exercise, user, sha)
      clones.find_by!(exercise_id: exercise.id, user_id: user.id).tap do |clone|
        clone.update_attributes!(parent_sha: sha, pending: false)
      end
    end

    def diff_fetched(clone, diff)
      clone.create_revision!(diff: diff)
    end
  end
end
