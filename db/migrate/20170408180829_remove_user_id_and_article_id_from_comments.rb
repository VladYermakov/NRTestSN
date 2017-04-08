class RemoveUserIdAndArticleIdFromComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :user_id, :string
    remove_column :comments, :article_id, :string
  end
end
