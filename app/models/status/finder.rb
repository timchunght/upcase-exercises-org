class Status::Finder
  pattr_initialize :candidates

  def find
    candidates.detect(&:applicable?)
  end
end
