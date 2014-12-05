module Git
  class ServerJob
    pattr_initialize [:method_name, :data]

    def perform
      NewRelic::Agent.set_transaction_name("Git::ServerJob##{method_name}")
      dependencies[:immediate_git_server].send(method_name, *data)
    end

    def error(job, exception)
      dependencies[:error_notifier].notify(exception)
    end

    private

    def dependencies
      Payload::RailsLoader.load
    end
  end
end
