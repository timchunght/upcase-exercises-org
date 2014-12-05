module Git
  # Decorates a Clone to add Git-specific functionality.
  class Clone < SimpleDelegator
    def initialize(clone, server)
      super(clone)
      @clone = clone
      @server = server
    end

    def repository
      @server.find_clone(@clone.exercise, @clone.user)
    end
  end
end
