module Gitolite
  # Uses a writer and a CommittableRepository to write changes to the Gitolite
  # configuration repository.
  class ConfigCommitter
    ADMIN_REPO_NAME = 'gitolite-admin'.freeze

    pattr_initialize [:config_writer, :repository_factory]

    def write(message)
      admin_repository.commit(message) { config_writer.write }
    end

    private

    def admin_repository
      repository_factory.new(path: ADMIN_REPO_NAME)
    end
  end
end
