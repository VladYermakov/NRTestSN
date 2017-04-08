class Article < ApplicationRecord
  belongs_to :user
  belongs_to :attachment, polymorphic: true, required: false
  has_many :articles, as: :attachment
  has_many :comments

  def as_json(options = {})
    super(options.merge(include: [:user, comments: { include: :user }]))
  end
end
