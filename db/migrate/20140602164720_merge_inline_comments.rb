class MergeInlineComments < ActiveRecord::Migration
  def up
    merge_inline_comments_into_comments
    drop_inline_comments_table
  end

  def down
    create_inline_comments_table
    split_inline_comments_from_comments
    delete_non_top_level_comments_from_comments
  end

  private

  def merge_inline_comments_into_comments
    say_with_time 'Merging inline_comments into comments' do
      insert(<<-SQL)
        INSERT INTO comments
          (user_id, solution_id, text, created_at, updated_at, location)
        SELECT
          inline_comments.user_id,
          revisions.solution_id,
          inline_comments.text,
          inline_comments.created_at,
          inline_comments.updated_at,
          concat(
            revisions.id :: varchar,
            ':',
            inline_comments.file_name,
            ':',
            inline_comments.line_number :: varchar
          )
        FROM inline_comments
        JOIN revisions ON revisions.id = inline_comments.revision_id
      SQL
    end
  end

  def drop_inline_comments_table
    drop_table :inline_comments
  end

  def create_inline_comments_table
    create_table :inline_comments do |t|
      t.integer :user_id, null: false
      t.integer :revision_id, null: false
      t.string :file_name, null: false
      t.integer :line_number, null: false
      t.text :text, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end

  def split_inline_comments_from_comments
    say_with_time 'Splitting inline_comments from comments' do
      insert(<<-SQL)
        WITH merged_comments AS (
          SELECT
            comments.*,
            string_to_array(comments.location, ':') AS location_parts
          FROM comments
          WHERE comments.location <> 'top-level'
        )
        INSERT INTO inline_comments (
          user_id,
          revision_id,
          file_name,
          line_number,
          text,
          created_at,
          updated_at
        )
        SELECT
          merged_comments.user_id,
          merged_comments.location_parts[1] :: integer as revision_id,
          merged_comments.location_parts[2] as file_name,
          merged_comments.location_parts[3] :: integer as line_number,
          merged_comments.text,
          merged_comments.created_at,
          merged_comments.updated_at
        FROM merged_comments
      SQL
    end
  end

  def delete_non_top_level_comments_from_comments
    say_with_time 'Deleting non-top-level comments from comments' do
      delete(<<-SQL)
        DELETE FROM comments WHERE location <> 'top-level'
      SQL
    end
  end

  def id_offset
    select_value(<<-SQL) || 0
      SELECT MAX(id) FROM comments
    SQL
  end
end
