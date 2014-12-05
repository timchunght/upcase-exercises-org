class AddSubscriberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscriber, :boolean, null: false, default: false
  end
end
