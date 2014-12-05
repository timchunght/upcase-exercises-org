module Gitolite
  # SSH public keys are required to authenticate Git over SSH.
  class PublicKey < ActiveRecord::Base
    validates :data, presence: true, uniqueness: true
    validates :user_id, presence: true
    validate :check_fingerprint

    private

    def check_fingerprint
      unless fingerprint.present?
        errors.add :data, 'did not contain a valid SSH public key'
      end
    end
  end
end
