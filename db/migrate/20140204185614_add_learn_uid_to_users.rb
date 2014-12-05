class AddLearnUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :learn_uid, :integer, null: false
    add_column :users, :auth_token, :string, null: false
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    change_column_null :users, :encrypted_password, true
    add_index :users, :learn_uid, unique: true
  end
end
