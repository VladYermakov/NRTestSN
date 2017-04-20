class Api::UsersController < ApplicationController

  def relationships_info
    user = User.find params[:id]
    respond_with following_count: user.followed_users.count,
                 followers_count: user.followers.count
  end

  def following
    user = User.find params[:id]
    respond_with user.followed_users_with_articles_and_comments
                           .as_json(include: { articles: { include: :comments } })
  end

  def followers
    user = User.find params[:id]
    respond_with user.followers_with_articles_and_comments
                           .as_json(include: { articles: { include: :comments } })
  end

  def feed
    respond_with current_user.followed_users_articles
  end
end
