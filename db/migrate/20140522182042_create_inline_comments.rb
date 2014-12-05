class CreateInlineComments < ActiveRecord::Migration
  def change
    create_table :inline_comments do |t|
      t.references :user, null: false, index: true
      t.references :revision, null: false, index: true
      t.string :file_name, null: false
      t.integer :line_number, null: false
      t.text :text, null: false
      t.index [:file_name, :line_number]

      t.timestamps null: false
    end
  end
end
