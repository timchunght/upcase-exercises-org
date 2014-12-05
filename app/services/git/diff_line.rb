module Git
  # Value object representing a line from a Git diff.
  class DiffLine
    pattr_initialize [:text, :changed, :file_name, :number]
    attr_reader :text, :number, :file_name

    def to_s
      if changed?
        "+#{text}"
      else
        " #{text}"
      end
    end

    def blank?
      text.blank?
    end

    def changed?
      changed
    end
  end
end
