class RemoveDuplicatePublicKeys < ActiveRecord::Migration
  def up
    delete <<-SQL.squish
      DELETE FROM public_keys
      WHERE id NOT IN (
        SELECT MAX(id)
        FROM public_keys
        GROUP BY data
      );
    SQL
  end
end
