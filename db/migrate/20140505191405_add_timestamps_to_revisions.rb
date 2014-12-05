class AddTimestampsToRevisions < ActiveRecord::Migration
  def up
    add_column :revisions, :created_at, :datetime
    change_column_null :revisions, :created_at, false, Time.now
    add_column :revisions, :updated_at, :datetime
    set_default_for_existing :revisions, :updated_at, :created_at
    change_column_null :revisions, :updated_at, true
    add_index :revisions, :created_at
  end

  def down
    remove_column :revisions, :created_at
    remove_column :revisions, :updated_at
  end

  private

  def set_default_for_existing(table, column, expression)
    update("UPDATE #{table} SET #{column} = #{expression}")
  end
end
