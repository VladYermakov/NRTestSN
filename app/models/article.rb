class Article < ApplicationRecord
  belongs_to :user
  belongs_to :attachment, polymorphic: true, required: false
  has_many :articles, as: :attachment
  has_many :comments

  default_scope -> { order(:created_at, :desc) }

  def self.from_users_followed_by(user)
    followed_users_id = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    where "user_id IN (#{followed_users_id})", user_id: user.id
  end

  def as_json(options = {})
    super(options.merge(include: [:user, comments: { include: :user }]))
  end
end
