class Comment < ApplicationRecord
  validates :user_id,    presence: true
  validates :article_id, presence: true
  validates :content,    presence: true, length: { maximum: 150 }

  belongs_to :user
  belongs_to :article
  has_many :articles, as: :attachment, dependent: :nullify

  def as_json(options = {})
    super(options.merge(include: [:user, :article]))
  end
end
