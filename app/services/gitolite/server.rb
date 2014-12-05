module Gitolite
  # Facade to present a cohesive interface to Gitolite-related classes.
  class Server
    include ::NewRelic::Agent::MethodTracer

    pattr_initialize [
      :config_committer,
      :observer,
      :repository_finder
    ]

    delegate :find_clone, :find_source, to: :repository_finder

    def create_clone(exercise, user)
      source = find_source(exercise)
      clone = find_clone(exercise, user)
      source.create_fork(clone.path)
      sha = clone.head
      observer.clone_created(exercise, user, sha)
    end

    def fetch_diff(clone)
      diff = find_clone(clone.exercise, clone.user).diff(clone.parent_sha)
      observer.diff_fetched(clone, diff)
    end

    def create_exercise(name)
      config_committer.write("Add exercise: #{name}")
    end

    def add_key(username)
      config_committer.write("Add public key for user: #{username}")
    end

    add_method_tracer :add_key
    add_method_tracer :create_clone
    add_method_tracer :create_exercise
    add_method_tracer :fetch_diff
  end
end
