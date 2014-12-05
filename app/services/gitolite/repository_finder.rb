module Gitolite
  class RepositoryFinder
    SOURCE_ROOT = 'sources'

    pattr_initialize :repository_factory

    def find_clone(exercise, user)
      repository_factory.new(path: "#{user.username}/#{exercise.slug}")
    end

    def find_source(exercise)
      repository_factory.new(path: "#{SOURCE_ROOT}/#{exercise.slug}")
    end
  end
end
