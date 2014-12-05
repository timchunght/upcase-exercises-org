class CreateClones < ActiveRecord::Migration
  def change
    create_table :clones do |t|
      t.references :user, null: false
      t.references :exercise, null: false

      t.timestamps null: false
    end

    add_index :clones, [:user_id, :exercise_id], unique: true
    add_index :clones, :exercise_id
  end
end
