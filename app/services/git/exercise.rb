module Git
  # Decorates an Exercise to add Git-specific functionality.
  class Exercise < SimpleDelegator
    def initialize(exercise, server)
      super(exercise)
      @exercise = exercise
      @server = server
    end

    def source
      @server.find_source(@exercise)
    end
  end
end
