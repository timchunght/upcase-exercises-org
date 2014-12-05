# Decorator which will notify an observer whenever a record is saved.
class ObservableRecord < SimpleDelegator
  def initialize(record, observer)
    super(record)
    @record = record
    @observer = observer
  end

  def save
    track_save { record.save }
  end

  def update_attributes(attributes)
    track_save { record.update_attributes(attributes) }
  end

  private

  attr_reader :record, :observer

  def track_save
    previously_persisted = record.persisted?

    if yield
      notify_saved(previously_persisted)
      true
    else
      false
    end
  end

  def notify_saved(previously_persisted)
    observer.saved(record)

    if previously_persisted
      observer.updated(record)
    else
      observer.created(record)
    end
  end
end
