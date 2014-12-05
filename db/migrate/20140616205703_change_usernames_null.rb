class ChangeUsernamesNull < ActiveRecord::Migration
  def up
    change_column_null :users, :username, true
  end

  def down
    update('UPDATE users SET username = id WHERE username IS NULL')
    change_column_null :users, :username, false
  end
end
