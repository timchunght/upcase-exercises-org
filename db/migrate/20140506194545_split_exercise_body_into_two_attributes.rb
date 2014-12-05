class SplitExerciseBodyIntoTwoAttributes < ActiveRecord::Migration
  def up
    add_column :exercises, :intro, :text

    say_with_time 'Adding default intros' do
      set_default_intros
    end

    change_column_null :exercises, :intro, false

    rename_column :exercises, :body, :instructions
  end

  def down
    rename_column :exercises, :instructions, :body

    remove_column :exercises, :intro
  end

  private

  def set_default_intros
    update("UPDATE exercises SET intro = 'Default intro'")
  end
end
