class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :articles, as: :attachment

  def as_json(options = {})
    super(options.merge(include: [:user, :article]))
  end
end
