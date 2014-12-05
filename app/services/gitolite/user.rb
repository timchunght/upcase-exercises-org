module Gitolite
  class User < SimpleDelegator
    def initialize(user, public_keys:)
      super(user)
      @public_keys = public_keys
    end

    def has_pending_public_keys?
      public_keys.pending?
    end

    private

    attr_reader :public_keys
  end
end
