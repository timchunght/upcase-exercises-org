class AddParentShaToClone < ActiveRecord::Migration
  def change
    add_column :clones, :parent_sha, :string
  end
end
