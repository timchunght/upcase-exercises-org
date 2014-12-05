class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :solution, index: true, null: false
      t.references :user, index: true, null: false
      t.index [:solution_id, :user_id], unique: true
      t.timestamps
    end
  end
end
