class AddSlugToExercises < ActiveRecord::Migration
  def up
    add_column :exercises, :slug, :string

    say_with_time 'Generating slugs' do
      ids_and_titles.each do |(id, title)|
        set_slug id, slugify(title)
      end
    end

    change_column_null :exercises, :slug, false

    add_index :exercises, :slug, unique: true
  end

  def down
    remove_index :exercises, column: :slug

    remove_column :exercises, :slug
  end

  private

  def ids_and_titles
    connection.select_rows('SELECT id, title FROM exercises')
  end

  def slugify(title)
    title.downcase.split(/\W+/).reject(&:blank?).join('-')
  end

  def set_slug(id, slug)
    connection.update(<<-SQL)
      UPDATE exercises SET slug = '#{slug}' WHERE id = #{id}
    SQL
  end
end
