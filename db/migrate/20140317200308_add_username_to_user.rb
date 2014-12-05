class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    connection.update('UPDATE users SET username = id')
    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end
end
