class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :relationships,         foreign_key: 'follower_id', dependent: :destroy
  has_many :reverse_relationships, foreign_key: 'followed_id',
                                   class_name: 'Relationship', dependent: :destroy
  has_many :followed_users, through: :relationships,        source: :followed
  has_many :followers,      through: :reverse_relationships

  def followed_users_articles
    Article.from_users_followed_by self
  end

  def followed_users_with_articles_and_comments
    followed_users.includes articles: :comments
  end

  def followers_with_articles_and_comments
    followers.includes articles: :comments
  end

  def following?(other_user)
    relationships.find_by followed_id: other_user.id
  end

  def follow(other_user)
    relationships.create! followed_id: other_user.id
  end

  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
end
