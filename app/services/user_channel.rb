# Determines which Pusher channel to use for events related to a user.
class UserChannel
  PREFIX = "user"
  DATA = ""

  pattr_initialize [:pusher!, :user_id!]

  def name
    "#{PREFIX}.#{user_id}"
  end

  def trigger(event)
    channel.trigger(event, DATA)
  end

  private

  def channel
    pusher[name]
  end
end
