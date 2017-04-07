class CreateAttachmentFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :attachment_files do |t|
      t.attachment :source

      t.timestamps
    end
  end
end
