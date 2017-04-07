class Article < ApplicationRecord
  belongs_to :user
  belongs_to :attachment, polymorphic: true
  has_many :articles, as: :attachment
  has_many :comments
end
