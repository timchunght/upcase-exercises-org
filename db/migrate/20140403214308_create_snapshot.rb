class CreateSnapshot < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.text :diff
      t.references :solution
    end
  end
end
