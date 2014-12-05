class AddPendingToPublicKeys < ActiveRecord::Migration
  def up
    add_column :public_keys, :pending, :boolean, null: false, default: true
    update("UPDATE public_keys SET pending = false")
    add_index :public_keys, :pending
  end

  def down
    remove_column :public_keys, :pending
  end
end
