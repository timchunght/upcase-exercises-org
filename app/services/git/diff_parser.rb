module Git
  # Parses diffs produced by `git diff` into files.
  class DiffParser
    include ::NewRelic::Agent::MethodTracer

    # Raises when unrecognized lines are encountered in diffs.
    class ParseError < StandardError
    end

    pattr_initialize :diff, :file_factory

    def parse
      @files = []
      diff.each_line do |line|
        process line
      end
      @files.reject(&:blank?)
    end

    private

    def process(line)
      case line
      when /^diff/
        start_file
      when /^\+\+\+ b\/(.*)/
        set_filename $1
      when /^\+(.*)/
        append_changed $1
      when /^ (.*)/
        append_unchanged $1
      when /^deleted file mode/
        delete_file
      when /^(index|-|@@|new file mode|old mode|new mode|\\)/
        # Ignore
      when /^Binary files .* and b\/(.*) differ/
        set_filename $1
        append_unchanged "# Binary file changed"
      else
        parse_error(line)
      end
    end

    def start_file
      @current_file = file_factory.new
      @files << @current_file
    end

    def delete_file
      @files.pop
    end

    def set_filename(name)
      current_file.name = name
    end

    def append_unchanged(line)
      current_file.append_unchanged line
    end

    def append_changed(line)
      current_file.append_changed line
    end

    def current_file
      @current_file || raise(ParseError, 'No file to modify')
    end

    def parse_error(line)
      raise ParseError, "Couldn't parse line: #{line.inspect}"
    end

    add_method_tracer :parse
  end
end
