module Gitolite
  # Shell adapter for Cocaine.
  class Shell
    def execute(command, *terms)
      Cocaine::CommandLine.new("(#{command}) 2>&1", *terms).run
    end
  end
end
