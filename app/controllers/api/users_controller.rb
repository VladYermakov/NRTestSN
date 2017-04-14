class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def following
    respond_with :api, current_user.followed_users_with_articles_and_comments
                                   .as_json(include: { articles: { include: :comments }})
  end

  def feed
    respond_with :api, current_user.followed_users_articles
  end
end
