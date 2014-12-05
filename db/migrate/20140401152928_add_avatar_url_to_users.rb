class AddAvatarUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_url, :string
    connection.update("UPDATE users SET avatar_url = '#{default_gravatar_url}'")
    change_column_null :users, :avatar_url, false
  end

  def default_gravatar_url
    'https://www.gravatar.com/avatar'
  end
end
