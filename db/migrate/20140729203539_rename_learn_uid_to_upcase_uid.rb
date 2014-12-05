class RenameLearnUidToUpcaseUid < ActiveRecord::Migration
  def change
    rename_column :users, :learn_uid, :upcase_uid
  end
end
