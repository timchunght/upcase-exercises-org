# Uses an omniauth hash to find or create a user from Upcase.
class Authenticator
  include ::NewRelic::Agent::MethodTracer

  pattr_initialize :auth_hash

  def authenticate
    find_or_initialize_user.tap do |user|
      update user
      add_username_to user
    end
  end

  private

  def find_or_initialize_user
    User.find_or_initialize_by(upcase_uid: uid)
  end

  def uid
    auth_hash['uid'].to_s
  end

  def update(user)
    user.update_attributes!(user_attributes)
  end

  def user_attributes
    {
      admin: info['admin'],
      auth_token: auth_hash['credentials']['token'],
      avatar_url: info['avatar_url'],
      email: info['email'],
      first_name: info['first_name'],
      last_name: info['last_name'],
      subscriber: info['has_active_subscription']
    }
  end

  def add_username_to(user)
    unless user.username?
      attempt_to_set user, :username, info['username']
    end
  end

  def attempt_to_set(user, attribute, value)
    unless user.update_attributes(attribute => value)
      user[attribute] = nil
    end
  end

  def info
    auth_hash['info']
  end

  add_method_tracer :authenticate
end
