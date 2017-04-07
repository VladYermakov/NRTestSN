class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string  :title
      t.text    :content
      t.integer :user_id
      t.integer :attachnment_id
      t.string  :attachnment_type

      t.timestamps
    end

    add_index :articles, [:attachnment_id, :attachnment_type]
  end
end
