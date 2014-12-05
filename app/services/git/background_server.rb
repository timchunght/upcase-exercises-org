module Git
  class BackgroundServer
    pattr_initialize :server, :job_factory

    delegate :find_clone, :find_source, to: :server

    def add_key(*args)
      job_factory.new(method_name: 'add_key', data: args)
    end

    def create_clone(*args)
      job_factory.new(method_name: 'create_clone', data: args)
    end

    def create_exercise(*args)
      job_factory.new(method_name: 'create_exercise', data: args)
    end

    def fetch_diff(*args)
      job_factory.new(method_name: 'fetch_diff', data: args)
    end
  end
end
