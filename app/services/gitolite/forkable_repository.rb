module Gitolite
  class ForkableRepository < SimpleDelegator
    include ::NewRelic::Agent::MethodTracer

    def initialize(repository, shell)
      super(repository)
      @repository = repository
      @shell = shell
    end

    def create_fork(target_path)
      shell.execute("ssh git@#{host} fork #{path} #{target_path}")
    end

    private

    attr_reader :repository, :shell
    add_method_tracer :create_fork
  end
end
