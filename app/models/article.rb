class Article < ApplicationRecord
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 90  }
  validates :content, presence: true, length: { maximum: 300 }

  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :attachment, polymorphic: true, required: false
  has_many :articles, as: :attachment
  has_many :comments, dependent: :destroy

  def self.from_users_followed_by(user)
    followed_users_id = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    where "user_id IN (#{followed_users_id})", user_id: user.id
  end

  def as_json(options = {})
    super(options.merge(include: :user))
  end
end
