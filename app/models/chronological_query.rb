class ChronologicalQuery < SimpleDelegator
  include Enumerable

  def initialize(relation)
    super(relation)
    @relation = relation
  end

  def each(&block)
    @relation.order(created_at: :asc).each(&block)
  end
end
