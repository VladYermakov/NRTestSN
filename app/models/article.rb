class Article < ApplicationRecord
  belongs_to :user
  belongs_to :attachnment, polymorphic: true
  has_many :articles, as: :attachnment
end
