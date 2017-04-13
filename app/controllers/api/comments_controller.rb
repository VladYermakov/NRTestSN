class Api::CommentsController < ApplicationBaseController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    respond_with :api, Comment.find_by article_id: params[:article_id]
  end

  def create
    respond_with :api, Comment.create comment_params.merge(user_id:    current_user.id,
                                                           article_id: params[:article_id])
  end

  def update
    comment = Comment.find params[:id]
    authorize! :update, comment
    respond_with :api, comment.update comment_params
  end

  def destroy
    comment = Comment.find params[:id]
    authorize! :delete, comment
    respond_with :api, comment.destroy
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
