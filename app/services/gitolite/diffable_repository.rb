module Gitolite
  class DiffableRepository < SimpleDelegator
    def initialize(repository, shell)
      super(repository)
      @repository = repository
      @shell = shell
    end

    def diff(sha)
      repository.in_local_clone do
        shell.execute("git diff #{sha} --unified=10000")
      end
    end

    private

    attr_reader :shell, :repository
  end
end
