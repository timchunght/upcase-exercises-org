class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |table|
      table.integer :clone_id, null: false
      table.timestamps null: false
    end

    add_index :solutions, :clone_id, unique: true
  end
end
