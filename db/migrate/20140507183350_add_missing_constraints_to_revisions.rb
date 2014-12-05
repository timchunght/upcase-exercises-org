class AddMissingConstraintsToRevisions < ActiveRecord::Migration
  def change
    change_column_null :revisions, :diff, false, ''
    change_column_null :revisions, :solution_id, false
    change_column_null :revisions, :updated_at, false
    add_index :revisions, :solution_id
  end
end
