class AddCommentsCountToSolutions < ActiveRecord::Migration
  def up
    add_column :solutions, :comments_count, :integer, default: 0, null: false
    add_index :solutions, :comments_count
    populate_counts :solutions, :comments_count, :comments, :solution_id
  end

  def down
    remove_column :solutions, :comments_count
  end

  private

  def populate_counts(cache_table, cache_column, source_table, foreign_key)
    say_with_time "Populating #{cache_table}.#{cache_column}" do
      update(<<-SQL)
        WITH counts AS (
          SELECT
            #{foreign_key} AS foreign_key,
            COUNT(*) AS count
          FROM #{source_table}
          GROUP BY #{foreign_key}
        )
        UPDATE #{cache_table}
        SET #{cache_column} = counts.count
        FROM counts
        WHERE #{cache_table}.id = counts.foreign_key
      SQL
    end
  end
end
