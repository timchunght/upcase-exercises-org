module Gitolite
  # Fake implementation of a shell to avoid running slow or destructive
  # commands during tests.
  class FakeShell
    attr_reader :commands

    def initialize
      @commands = []
    end

    def execute(*args)
      command = args.join(' ')
      @commands << command
      self.class.stubs.run(command)
    end

    def self.with_stubs
      old_stubs = stubs.dup
      begin
        yield stubs
      ensure
        @stubs = old_stubs
      end
    end

    def self.stub
      @stubs = Stubs.new
      yield stubs
    end

    private

    def self.stubs
      @stubs ||= Stubs.new
    end

    class Stubs
      def initialize
        @handlers = []
      end

      def add(pattern, &handler)
        handlers.unshift [pattern, handler]
      end

      def run(command)
        normalize_output output_from(command)
      end

      def dup
        Stubs.new.tap do |stubs|
          stubs.handlers = handlers.dup
        end
      end

      protected

      attr_accessor :handlers

      private

      def output_from(command)
        pattern, handler = find(command)
        if pattern
          match = pattern.match(command)
          handler.call(*match.captures)
        end
      end

      def find(command)
        handlers.detect do |(pattern, _)|
          pattern =~ command
        end
      end

      def normalize_output(result)
        output = result.to_s
        if output.present?
          "#{output.rstrip}\n"
        else
          ''
        end
      end
    end
  end
end
