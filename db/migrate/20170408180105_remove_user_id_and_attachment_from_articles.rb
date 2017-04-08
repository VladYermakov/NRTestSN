class RemoveUserIdAndAttachmentFromArticles < ActiveRecord::Migration[5.0]
  def change
    remove_column :articles, :user_id, :string
    remove_column :articles, :attachment_id, :string
    remove_column :articles, :attachment_type, :string
  end
end
