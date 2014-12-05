module Git
  # Revision with files parsed from a Git diff.
  class Revision < SimpleDelegator
    def initialize(revision, parser_factory)
      super(revision)
      @parser_factory = parser_factory
    end

    def files
      parser_factory.new(diff: diff).parse
    end

    private

    attr_reader :parser_factory
  end
end
