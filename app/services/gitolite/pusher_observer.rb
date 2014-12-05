module Gitolite
  # Notifies Pusher when server-side changes occur so that the UI can update.
  class PusherObserver
    PREFIX = "public_keys"

    pattr_initialize :channel_factory

    def key_uploaded(user_id: user_id)
      channel_factory.new(user_id: user_id).trigger("uploaded_key")
    end
  end
end
