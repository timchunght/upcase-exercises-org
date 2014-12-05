class AddFingerprintToPublicKeys < ActiveRecord::Migration
  def up
    add_column :public_keys, :fingerprint, :string
    change_column_null :public_keys, :fingerprint, false, 'UNKNOWN'
  end

  def down
    remove_column :public_keys, :fingerprint
  end
end
