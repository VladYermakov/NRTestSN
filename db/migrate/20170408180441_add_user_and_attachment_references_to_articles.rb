class AddUserAndAttachmentReferencesToArticles < ActiveRecord::Migration[5.0]
  def change
    add_reference :articles, :user, foreign_key: true
    add_reference :articles, :attachment, polymorphic: true
  end
end
