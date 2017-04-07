class RenameAttachnmentToAttachment < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles, :attachnment_id, :attachment_id
    rename_column :articles, :attachnment_type, :attachment_type
  end
end
