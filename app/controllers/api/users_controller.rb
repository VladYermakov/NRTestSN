class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def following
    respond_with :api, current_user.followed_users
  end

  def feed
    respond_with :api, current_user.followed_users_articles
  end
end
