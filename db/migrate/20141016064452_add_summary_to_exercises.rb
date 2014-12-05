class AddSummaryToExercises < ActiveRecord::Migration
  def up
    add_column :exercises, :summary, :text, null: false, default: ""
    change_column_default :exercises, :summary, nil
  end

  def down
    remove_column :exercises, :summary
  end
end
