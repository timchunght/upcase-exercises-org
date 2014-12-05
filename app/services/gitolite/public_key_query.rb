module Gitolite
  class PublicKeyQuery
    pattr_initialize [:relation!, :observer!]

    def for(user)
      by_user[user.id] || []
    end

    def pending?
      relation.where(pending: true).exists?
    end

    def clear_pending
      preload
      yield
      update_preloaded(pending: false)
      notify_observer
    end

    private

    attr_reader :pending, :preloaded

    def by_user
      preload
      @by_user ||= preloaded.group_by(&:user_id)
    end

    def preload
      @preloaded ||= relation.to_a
      @pending ||= relation.where(pending: true).to_a
    end

    def update_preloaded(updates)
      relation.where(id: preloaded).update_all(updates)
    end

    def notify_observer
      uploaded_user_ids.each do |uploaded_user_id|
        observer.key_uploaded(user_id: uploaded_user_id)
      end
    end

    def uploaded_user_ids
      preload
      pending.map(&:user_id).uniq
    end
  end
end
