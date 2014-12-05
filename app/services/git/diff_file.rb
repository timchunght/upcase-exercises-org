module Git
  # File from a parsed GitDiff, consisting of a name and lines.
  #
  # This class is mutable so that it can be statefully created from a diff
  # parser.
  class DiffFile
    attr_accessor :name

    def initialize(line_factory, limit)
      @line_factory = line_factory
      @limit = limit
      @lines = []
    end

    def blank?
      lines.blank?
    end

    def append_unchanged(line)
      append_line(line, changed: false)
    end

    def append_changed(line)
      append_line(line, changed: true)
    end

    def each_line(&block)
      lines.each(&block)
    end

    private

    attr_reader :limit, :lines, :line_factory

    def append_line(text, attributes)
      if next_line_number <= limit
        lines << line_factory.new(
          {
            text: text,
            file_name: name,
            number: next_line_number
          }.merge(attributes)
        )
      end
    end

    def next_line_number
      lines.length + 1
    end
  end
end
