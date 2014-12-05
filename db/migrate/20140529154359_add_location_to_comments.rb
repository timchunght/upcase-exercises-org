class AddLocationToComments < ActiveRecord::Migration
  def change
    add_column :comments, :location, :string
    change_column_null :comments, :location, false, 'top-level'
  end
end
