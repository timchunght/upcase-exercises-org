class FakeRecord
  def initialize(valid:, persisted:)
    @valid = valid
    @persisted = persisted
  end

  def save
    if @valid
      @persisted = true
    end

    @valid
  end

  def update_attributes(_attributes)
    save
  end

  def persisted?
    @persisted
  end
end
