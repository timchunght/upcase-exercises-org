class RenameSnapshotsToRevisions < ActiveRecord::Migration
  def change
    rename_table :snapshots, :revisions
  end
end
