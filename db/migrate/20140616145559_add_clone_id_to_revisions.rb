class AddCloneIdToRevisions < ActiveRecord::Migration
  def up
    add_column :revisions, :clone_id, :integer
    backfill_reference :revisions, :clone_id, :solutions, :solution_id
    change_column_null :revisions, :clone_id, false
    change_column_null :revisions, :solution_id, true
    add_index :revisions, :clone_id
  end

  def down
    delete('DELETE FROM revisions WHERE solution_id IS NULL')
    change_column_null :revisions, :solution_id, false
    remove_column :revisions, :clone_id
  end

  private

  def backfill_reference(table, reference, source_table, source_reference)
    say_with_time "Backfilling #{table}.#{reference}" do
      update(<<-SQL)
        UPDATE #{table}
        SET #{reference} = #{source_table}.#{reference}
        FROM #{source_table}
        WHERE #{source_table}.id = #{table}.#{source_reference}
      SQL
    end
  end
end
