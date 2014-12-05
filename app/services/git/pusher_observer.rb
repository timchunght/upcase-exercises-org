module Git
  # Notifies Pusher when server-side changes occur so that the UI can update.
  class PusherObserver
    pattr_initialize :channel_factory

    def clone_created(_exercise, user, _sha)
      channel_factory.new(user_id: user.id).trigger("cloned")
    end

    def diff_fetched(clone, _diff)
      channel_factory.new(user_id: clone.user_id).trigger("pushed")
    end
  end
end
