class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false
      t.references :solution, null: false, index: true
      t.text :text, null: false

      t.timestamps null: false
    end
  end
end
