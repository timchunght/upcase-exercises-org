class NumberedRevision < SimpleDelegator
  def initialize(revision, siblings)
    super(revision)
    @siblings = siblings
  end

  def number
    ids = siblings.order(:created_at).map(&:id)
    index = ids.find_index(id)
    index + 1
  end

  private

  attr_reader :siblings
end
