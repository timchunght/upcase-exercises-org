class AddUuidToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :uuid, :string, null: true
    add_index :exercises, :uuid, unique: true
    update "UPDATE exercises SET uuid=md5(random()::text)"
    change_column_null :exercises, :uuid, false
  end
end
