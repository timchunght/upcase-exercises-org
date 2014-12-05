class AddPendingToClones < ActiveRecord::Migration
  def up
    add_column :clones, :pending, :boolean, null: false, default: false
    change_column_default :clones, :pending, true
  end

  def down
    remove_column :clones, :pending
  end
end
