class Api::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def show
    respond_with :api,
      !current_user.following?(User.find params[:followed_id]).nil?, location: nil
  end

  def create
    current_user.follow User.find params[:followed_id]
    respond_with :api, current_user
  end

  def destroy
    current_user.unfollow User.find params[:followed_id]
    respond_with :api, current_user
  end
end
