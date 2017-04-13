class Api::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.follow User.find params[:followed_id]
  end

  def destroy
    Relationships.find(params[:id]).destroy
  end
end
