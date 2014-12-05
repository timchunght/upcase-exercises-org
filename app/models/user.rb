class User < ActiveRecord::Base
  include Clearance::User
  extend FriendlyId

  has_many :clones, dependent: :destroy
  has_many :public_keys, dependent: :destroy, class_name: 'Gitolite::PublicKey'
  has_many :subscriptions, dependent: :destroy

  validates(
    :username,
    allow_nil: true,
    format: /\A[a-zA-Z0-9_-]+\z/,
    uniqueness: true,
  )

  friendly_id :username, use: [:finders]

  def self.admin_usernames
    admins.by_username.usernames
  end

  def self.by_username
    order(:username)
  end

  private

  def self.admins
    where(admin: true)
  end

  def self.usernames
    pluck(:username)
  end

  def password_optional?
    true
  end
end
