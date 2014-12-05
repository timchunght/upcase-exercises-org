module Gitolite
  # Decorates a config committer to clear pending public keys.
  class PublicKeyTrackingCommitter
    pattr_initialize :committer, [:public_keys!]

    def write(message)
      public_keys.clear_pending do
        committer.write(message)
      end
    end
  end
end
