# Decorates a message and ignores deliveries to the filtered address.
class FilteredMessage
  pattr_initialize :message, [:filter!, :recipient!]

  def deliver
    if unfiltered?
      message.deliver
    end
  end

  private

  def unfiltered?
    filter != recipient
  end
end
