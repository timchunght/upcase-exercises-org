module Gitolite
  class RepositoryWithHistory < SimpleDelegator
    include ::NewRelic::Agent::MethodTracer

    def initialize(repository, shell)
      super(repository)
      @repository = repository
      @shell = shell
    end

    def head
      repository.in_local_clone do
        shell.execute('git rev-parse HEAD').strip
      end
    end

    private

    attr_reader :repository, :shell
    add_method_tracer :head
  end
end
